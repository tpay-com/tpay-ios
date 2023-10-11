//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension FullScreenTransitioningDelegate {
    
    final class DismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            0.2
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let controller = transitionContext.viewController(forKey: .from) else { return }
            let duration = transitionDuration(using: transitionContext)
            
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
                controller.view.alpha = 0
            }

            animator.addCompletion { position in
                transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                if position != .end {
                    controller.view.removeFromSuperview()
                }
            }

            animator.startAnimation()
        }
    }
}
