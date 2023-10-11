//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

protocol SceneObserver: AnyObject {
    
    @available(iOS 13.0, *)
    func notifyActivate<Observer: AnyObject>(on observer: Observer, then: @escaping (Observer) -> Void)
    
}
