//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension DefaultViewControllerPresenter.TransitioningDelegate {
    
    final class PresentationController: UIPresentationController {
        
        // MARK: - Properties
        
        // TODO: - Style should be configured from outside of the framework
        private let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
        // MARK: - Lifecycle
        
        override func presentationTransitionWillBegin() {
            super.presentationTransitionWillBegin()
            
            guard let containerView = containerView else { return }
            
            containerView.addSubview(dimmingView)
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            
            dimmingView.alpha = 0
            
            presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [dimmingView] _ in
                dimmingView.alpha = 1
            })
        }
        
        override func presentationTransitionDidEnd(_ completed: Bool) {
            super.presentationTransitionDidEnd(completed)
            
            if completed == false {
                dimmingView.removeFromSuperview()
            }
        }
        
        override func dismissalTransitionWillBegin() {
            super.dismissalTransitionWillBegin()
            
            presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [dimmingView] _ in
                dimmingView.alpha = 0
            })
        }
        
        override func dismissalTransitionDidEnd(_ completed: Bool) {
            super.dismissalTransitionDidEnd(completed)
            
            switch completed {
            case true: dimmingView.removeFromSuperview()
            case false: dimmingView.alpha = 1
            }
        }
        
    }
    
}
