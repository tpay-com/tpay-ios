//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController.TransitioningDelegate {
    
    final class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            0.3
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let controller = transitionContext.viewController(forKey: .to) else { return }
            transitionContext.containerView.addSubview(controller.view)
            
            let destinationFrame = transitionContext.finalFrame(for: controller)
            var sourceFrame = destinationFrame
            sourceFrame.origin.y += destinationFrame.height
            
            let duration = transitionDuration(using: transitionContext)
            controller.view.frame = sourceFrame
            
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
