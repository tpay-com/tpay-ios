//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol BanksService: AnyObject {
    
    // MARK: - Properties
    
    var banks: [Domain.PaymentMethod.Bank] { get }
    
}
