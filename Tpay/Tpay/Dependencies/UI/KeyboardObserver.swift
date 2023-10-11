//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

protocol KeyboardObserver: AnyObject {
    
    func notifyKeyboardChanges(on view: KeyboardAware)
    func notifyKeyboardChanges<Observer: AnyObject>(on observer: Observer, changes: @escaping (Observer, KeyboardAppearancePayload) -> Void)
    
}
