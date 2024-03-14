//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension CardToken {
    
    // TODO: Adjust to tpay OpenAPI after tokenization rework

    public enum Brand {
        
        // MARK: - Cases
        
        case mastercard
        case visa
        case other(String)
    }
}
