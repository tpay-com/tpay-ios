//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
extension UINavigationBarAppearance {
    
    final class Builder {
        
        // MARK: - Properties
        
        private let appearance: UINavigationBarAppearance
        
        // MARK: - Initialization
        
        convenience init() {
            self.init(appearance: UINavigationBarAppearance())
        }
        
        init(appearance: UINavigationBarAppearance) {
            self.appearance = appearance
        }
        
        // MARK: - API
        
        func build() -> UINavigationBarAppearance { appearance }
        
        func set(backgroundColor: UIColor) -> Self {
            appearance.backgroundColor = backgroundColor
            return self
        }
        
        func set(textColor: UIColor) -> Self {
            appearance.titleTextAttributes[.foregroundColor] = textColor
            appearance.largeTitleTextAttributes[.foregroundColor] = textColor
            return self
        }

        func set(largeTitleIndent indent: CGFloat) -> Self {
            let style = NSMutableParagraphStyle()
            style.firstLineHeadIndent = indent
            style.headIndent = indent
            appearance.largeTitleTextAttributes[.paragraphStyle] = style
            return self
        }
        
        func set(shadowColor: UIColor) -> Self {
            appearance.shadowColor = shadowColor
            return self
        }
        
        func set(backgroundEffect: UIBlurEffect?) -> Self {
            appearance.backgroundEffect = backgroundEffect
            return self
        }
        
        func set(backIndicatorImage: UIImage, transitionMaskImage backIndicatorTransitionMaskImage: UIImage) -> Self {
            appearance.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorTransitionMaskImage)
            return self
        }
        
        /// Calling this method restores the default appearance
        func configureDimmingBackground() -> Self {
            appearance.configureWithDefaultBackground()
            return self
        }
        
        /// Calling this method restores the default appearance
        func configureTransparentBackground() -> Self {
            appearance.configureWithTransparentBackground()
            return self
        }
        
    }
    
}
