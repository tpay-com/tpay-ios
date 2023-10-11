//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

public protocol Presentable: AnyObject {
    
    // MARK: - API
    
    func present(from: UIViewController) throws
    func dismiss()
}
