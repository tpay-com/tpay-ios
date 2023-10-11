//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func endEditingOnTap() {
        let gestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
}
