//
//  Copyright © 2022 Tpay. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

final class CardDetector {
    
    // MARK: - Events
    
    let cardScanningStatus = Observable<CardScanningStatus>()
    let detectedRectangle = Observable<CGImage>()
    
    // MARK: - Properties
    
    private let rectangleQueue: DispatchQueue
    private let cameraPreviewLayer: VideoPreviewLayer
    private let numberOfAttempts: Int = 10
    
    private var rectanglesRequest: VNDetectRectanglesRequest?
    private var inputImage: CIImage?
    
    private var acceptanceArea: CGRect = .zero
    private var failAttempts: Int = 0
    private var successAttempts: Int = 0
    
    // MARK: - Initializers
    
    init(cameraPreviewLayer: VideoPreviewLayer) {
        self.cameraPreviewLayer = cameraPreviewLayer
        rectangleQueue = DispatchQueue(label: "com.tpay.scanning.rectangleDetection")
        
        configureRequest()
    }
    
    // MARK: - API
    
    func set(acceptanceArea: CGRect) {
        self.acceptanceArea = acceptanceArea
    }
    
    func detect(_ liveImage: CIImage) {
        guard let rectanglesRequest = rectanglesRequest else { return }
        
        inputImage = liveImage
        
        let handler = VNImageRequestHandler(ciImage: liveImage, orientation: .up)
        do {
            try handler.perform([rectanglesRequest])
        } catch {
            Logger.error("Error: Vision request failed with error \"\(error)\"")
        }
    }
    
    func resetAttempts() {
        failAttempts = 0
        successAttempts = 0
    }
    // MARK: - Private
    
    private func configureRequest() {
        rectanglesRequest = VNDetectRectanglesRequest(completionHandler: { [weak self] req, err in self?.handleRequest(request: req, error: err) })
        rectanglesRequest?.minimumAspectRatio = VNAspectRatio(Constants.rectangleMinAspectRatio)
        rectanglesRequest?.maximumAspectRatio = VNAspectRatio(Constants.rectangleMaxAspectRatio)
        rectanglesRequest?.maximumObservations = 1
    }
    
    private func handleRequest(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRectangleObservation],
              let rectangle = observations.first,
              let inputImage = inputImage else { return }
        
        let imageSize = inputImage.extent.size
        
        let scaledWidth = (imageSize.width / imageSize.height) * cameraPreviewLayer.frame.height
        
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -cameraPreviewLayer.frame.height)
        let scale = CGAffineTransform.identity.scaledBy(x: scaledWidth, y: cameraPreviewLayer.frame.height)
        let rectangleBounds = rectangle.boundingBox.applying(scale).applying(transform)
        
        let updatedLeftMargin = (scaledWidth - acceptanceArea.width) / 2
        let updatedRect = CGRect(x: updatedLeftMargin,
                                 y: acceptanceArea.origin.y,
                                 width: acceptanceArea.width,
                                 height: acceptanceArea.height)
        
        if updatedRect.contains(rectangleBounds) {
            successAttempts += 1
            
            if successAttempts == 5 {
                cardScanningStatus.on(.next(.documentInRange))
            }
            
            if successAttempts == numberOfAttempts {
                guard let cardImage = getCardImage(for: inputImage, rectangleObservation: rectangle) else {
                    cardOutOfRange()
                    return
                }
                cardInRange(for: cardImage)
            }
        } else {
            failAttempts += 1
            if failAttempts == numberOfAttempts {
                cardOutOfRange()
            }
        }
    }
    
    private func cardInRange(for image: CGImage) {
        failAttempts = 0
        cardScanningStatus.on(.next(.documentInRange))
        detectedRectangle.on(.next(image))
    }
    
    private func cardOutOfRange() {
        successAttempts = 0
        cardScanningStatus.on(.next(.documentOutOfRange))
    }
    
    private func getCardImage(for inputImage: CIImage, rectangleObservation: VNRectangleObservation) -> CGImage? {
        let topLeft = rectangleObservation.topLeft.scaled(to: inputImage.extent.size)
        let topRight = rectangleObservation.topRight.scaled(to: inputImage.extent.size)
        let bottomLeft = rectangleObservation.bottomLeft.scaled(to: inputImage.extent.size)
        let bottomRight = rectangleObservation.bottomRight.scaled(to: inputImage.extent.size)
        
        let correctedCIImage = inputImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: topLeft),
            "inputTopRight": CIVector(cgPoint: topRight),
            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
            "inputBottomRight": CIVector(cgPoint: bottomRight)
        ]).oriented(.left)
        
        return CIContext().createCGImage(correctedCIImage, from: correctedCIImage.extent)
    }
}

private extension CGPoint {
    
    func scaled(to size: CGSize) -> CGPoint {
        CGPoint(x: self.x * size.width,
                y: self.y * size.height)
    }
}
