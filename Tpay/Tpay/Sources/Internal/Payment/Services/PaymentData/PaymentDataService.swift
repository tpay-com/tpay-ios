//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PaymentDataService: AnyObject {

    // MARK: - API
    
    func fetchChannels(then: @escaping Completion)
}
