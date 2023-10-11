//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol FailureViewModel {
    
    // MARK: - Properties
    
    var content: FailureContent { get }
    
    // MARK: - API
    
    func primaryAction()
    func cancel()
}
