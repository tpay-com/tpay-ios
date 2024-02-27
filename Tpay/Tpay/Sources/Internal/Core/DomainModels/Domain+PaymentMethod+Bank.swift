//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain.PaymentMethod {
    
    struct Bank: Equatable, Hashable {
        
        // MARK: - Properties
        
        let id: String
        let name: String
        let imageUrl: URL?
    }
}

extension Domain.PaymentMethod.Bank {

    // MARK: - Properties

    static let any = Domain.PaymentMethod.Bank(id: .empty, name: .empty, imageUrl: nil)
}
