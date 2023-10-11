//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController.TransitioningDelegate {
    
    final class DismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            0.3
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let controller = transitionContext.viewController(forKey: .from) else { return }
            
            let sourceFrame = transitionContext.finalFrame(for: controller)
            var destinationFrame = sourceFrame
            destinationFrame.origin.y += sourceFrame.height
            
            let duration = transitionDuration(using: transitionContext)
            
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
                controller.view.frame = destinationFrame
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
