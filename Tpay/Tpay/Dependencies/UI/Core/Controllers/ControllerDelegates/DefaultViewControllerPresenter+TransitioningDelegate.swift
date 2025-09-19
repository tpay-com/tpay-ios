//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension DefaultViewControllerPresenter {
    
    final class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
        
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            PresentAnimation()
        }
        
        func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            PresentationController(presentedViewController: presented, presenting: presenting)
        }
        
    }

}
