//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController.TransitioningDelegate {
    
    final class PresentationController: UIPresentationController {
        
        // MARK: - Properties
        
        private let dimmingView: UIView = {
            let view = UIView()
            view.backgroundColor = .black.withAlphaComponent(0.2)
            return view
        }()
        
        // MARK: - Lifecycle
        
        override func presentationTransitionWillBegin() {
            super.presentationTransitionWillBegin()
            
            guard let containerView = containerView else { return }
            
            dimmingView.layout
                .add(to: containerView)
                .embed(in: containerView)
                .activate()
            
            dimmingView.alpha = 0
            
            presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [dimmingView] _ in
                dimmingView.alpha = 1
            })
        }
        
        override func presentationTransitionDidEnd(_ completed: Bool) {
            super.presentationTransitionDidEnd(completed)
            
            guard completed == true else {
                dimmingView.removeFromSuperview()
                return
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
