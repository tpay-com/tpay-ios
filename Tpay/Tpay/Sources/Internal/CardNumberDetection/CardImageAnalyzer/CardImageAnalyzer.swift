//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit
import Vision

@available(iOS 13.0, *)
final class CardImageAnalyzer {
    
    // MARK: - Type aliases
    
    private typealias CreditCard = CardNumberDetectionModels.CreditCard
    
    // MARK: - Events
    
    let analysisResult = Observable<CardImageAnalyzer.Result>()
    
    // MARK: - Properties
    
    private let cardDataQueue = DispatchQueue(label: "com.tpay.scanning.cardData")
    private let cardNumberValidator = CardNumberValidation()
    private let expiryDateValidator = CardExpiryDateValidation()
    
    private(set) lazy var cardDataRequest = VNRecognizeTextRequest(completionHandler: handleRequest)
    
    // MARK: - API
    
    func analyze(image: CGImage) {
        let handler = VNImageRequestHandler(cgImage: image, orientation: .up)
        
        do {
            try handler.perform([cardDataRequest])
        } catch {
            Logger.error("Error: Vision request failed with error \"\(error)\"")
        }
    }
    
    // MARK: - Private
    
    private func handleRequest(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
        var cardNumber: String?
        var cardBrand: CreditCard.Brand?
        var expiryDate: String?
        
        for observation in observations {
            guard let candidate = observation.topCandidates(Constants.maxCandidates).first else { continue }
            
            cardNumberValidator.validate(candidate.string.removeWhitespacesAndNewlines().removeDashes())
            expiryDateValidator.validate(candidate.string)
            
            if cardNumberValidator.isValid {
                cardNumber = candidate.string
                cardBrand = cardNumberValidator.brand
            }
            
            if expiryDateValidator.isValid {
                expiryDate = candidate.string
            }
        }
        
        guard let cardNumber = cardNumber,
              let cardBrand = cardBrand else {
            analysisResult.on(.next(.failure))
            return
        }
        
        analysisResult.on(.next(.success(CreditCard(number: cardNumber, expiryDate: expiryDate, brand: cardBrand))))
    }
}
