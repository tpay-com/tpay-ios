//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension DefaultViewControllerPresenter.TransitioningDelegate {
    
    final class PresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.5 }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let appearingView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }
            
            let container = transitionContext.containerView
                        
            container.addSubview(appearingView)
            appearingView.translatesAutoresizingMaskIntoConstraints = false
            
            appearingView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            appearingView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            appearingView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            
            // TODO: - Calculate height
            appearingView.layer.transform = CATransform3DMakeTranslation(0, container.bounds.height, 0)

            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeIn) {
                appearingView.layer.transform = CATransform3DIdentity
            }
            
            animator.addCompletion { position in
                transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                if position != .end {
                    appearingView.removeFromSuperview()
                }
            }
            
            animator.startAnimation()
        }
        
    }
    
}
