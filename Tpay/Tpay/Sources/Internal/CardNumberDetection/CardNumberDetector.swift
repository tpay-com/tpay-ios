//
//  Copyright © 2022 Tpay. All rights reserved.
//

import AVFoundation
import UIKit

@available(iOS 13.0, *)
final class CardNumberDetector: NSObject {
    
    // MARK: - Events
    
    let creditCardData = Observable<CardNumberDetectionModels.CreditCard>()
    private(set) lazy var cardStatus = cardDetector.cardScanningStatus
    
    // MARK: - Properties
    
    let cameraPreviewLayer: VideoPreviewLayer
    
    private let captureSession: CaptureSession
    private let videoDataOutput = VideoDataOutput()
    private let cardDetector: CardDetector
    private let cardImageAnalyzer = CardImageAnalyzer()
    private let videoOutputQueue = DispatchQueue(label: "com.tpay.scanning.videoDataOutput")
    
    private var detectionArea: CGRect = .zero
    private var timeoutTimer: Timer?
    private var isDetectionEnabled = false
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    override init() {
        captureSession = CaptureSession(dataOutput: videoDataOutput)
        cameraPreviewLayer = VideoPreviewLayer(session: captureSession)
        cardDetector = CardDetector(cameraPreviewLayer: cameraPreviewLayer)
        super.init()
        
        videoDataOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        
        observeEvents()
    }
    
    // MARK: - API
    
    func set(detectionArea: CGRect) {
        self.detectionArea = detectionArea
        cardDetector.set(acceptanceArea: detectionArea)
    }
    
    func set(videoArea: CGRect) {
        cameraPreviewLayer.bounds = videoArea
    }
    
    func startSession() {
        captureSession.startRunning()
        startDetection()
    }
    
    func stopSession() {
        stopDetection()
        captureSession.stopRunning()
    }
    
    func startDetection() {
        cardStatus.on(.next(.documentOutOfRange))
        cardDetector.resetAttempts()
        isDetectionEnabled = true
        setTimer()
    }
    
    func stopDetection() {
        isDetectionEnabled = false
    }
    
    // MARK: - Private
    
    private func observeEvents() {
        cardDetector.detectedRectangle
            .subscribe(queue: .main, onNext: { [weak self] rectangleImage in
                self?.stopDetection()
                self?.rectangleDeteced(rectangleImage)
            })
            .add(to: disposer)
        
        cardImageAnalyzer.analysisResult
            .subscribe(queue: .main, onNext: { [weak self] result in self?.analysisResult(result) })
            .add(to: disposer)
    }
    
    @objc private func timeout() {
        stopDetection()
        cardStatus.on(.next(.failed))
        resetTimer()
    }
    
    private func resetTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
    
    private func setTimer() {
        if timeoutTimer == nil {
            timeoutTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(CardNumberDetector.timeout), userInfo: nil, repeats: false)
        }
    }
    
    private func analysisResult(_ result: CardImageAnalyzer.Result) {
        resetTimer()
        switch result {
        case .success(let creditCard):
            creditCardData.on(.next(creditCard))
        case .failure:
            cardStatus.on(.next(.failed))
        }
    }
    
    private func rectangleDeteced(_ rectangleImage: CGImage) {
        stopDetection()
        cardImageAnalyzer.analyze(image: rectangleImage)
    }
}

// MARK: - Video Delegate

@available(iOS 13.0, *)
extension CardNumberDetector: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isDetectionEnabled,
                let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        cardDetector.detect(CIImage(cvPixelBuffer: pixelBuffer))
    }
}
