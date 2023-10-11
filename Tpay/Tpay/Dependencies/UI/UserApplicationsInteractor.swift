//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

protocol UserApplicationsInteractor: AnyObject {
    
    func open(_ scheme: UserApplication) throws
    
    func share(_ url: URL)
    
}
