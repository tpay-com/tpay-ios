//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension TransactionDTO.Payments {
    
    struct Attempt: Decodable {
        
        let paymentErrorCode: AttemptError?
        
        // MARK: - Initializers
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            paymentErrorCode = try container.decodeIfPresent(AttemptError.self, forKey: .paymentErrorCode)
        }
    }
}

extension TransactionDTO.Payments.Attempt {
    
    private enum CodingKeys: CodingKey {
        
        // MARK: - Cases
        
        case paymentErrorCode
    }
}
