//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension FullScreenTransitioningDelegate {
    
    final class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            0.2
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let controller = transitionContext.viewController(forKey: .to) else { return }
            transitionContext.containerView.addSubview(controller.view)

            let destinationFrame = transitionContext.finalFrame(for: controller)
            controller.view.frame = destinationFrame
            
            controller.view.alpha = 0
            
            let duration = transitionDuration(using: transitionContext)

            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
                controller.view.alpha = 1
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
