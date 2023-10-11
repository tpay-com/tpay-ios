//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension FullScreenTransitioningDelegate {
    
    final class PresentationController: UIPresentationController {
        
        override var frameOfPresentedViewInContainerView: CGRect {
            guard let containerView = containerView else { return .zero }
            return containerView.bounds
        }
    }
}
