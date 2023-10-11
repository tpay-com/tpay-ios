//
//  Copyright © 2022 Tpay. All rights reserved.
//

@available(iOS 13.0, *)
extension CardImageAnalyzer {
    
    enum Result {
        
        // MARK: - Cases
        
        case success(CardNumberDetectionModels.CreditCard)
        case failure
    }
}
