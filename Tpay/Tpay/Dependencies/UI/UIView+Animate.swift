//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension UIView {

    func layoutWithAnimation(duration: TimeInterval = 0.2) {
        guard window != nil else { return }
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }

    func animate<ViewType: UIView>(_ subview: ViewType, for duration: TimeInterval, animationBlock: @escaping (ViewType) -> Void) {
        animate(subview, for: duration, animationBlock: animationBlock, completion: { _ in })
    }

    func animate<ViewType: UIView>(_ subview: ViewType, for duration: TimeInterval, animationBlock: @escaping (ViewType) -> Void, completion: @escaping (Bool) -> Void) {
        let complete = {
            animationBlock(subview)
            completion(true)
        }

        guard subview.window != nil else { return complete() }

        UIView.animate(withDuration: duration, animations: { animationBlock(subview) }, completion: completion)
    }

    func animate(_ first: UIView, second: UIView, for duration: TimeInterval, animationBlock: @escaping (UIView, UIView) -> Void) {
        animate(first, second: second, for: duration, animationBlock: animationBlock, completion: { _ in })
    }

    func animate(_ first: UIView, second: UIView, for duration: TimeInterval, animationBlock: @escaping (UIView, UIView) -> Void, completion: @escaping (Bool) -> Void) {
        let complete = {
            animationBlock(first, second)
            completion(true)
        }

        guard first.window != nil else { return complete() }
        guard second.window != nil else { return complete() }

        UIView.animate(withDuration: duration, animations: { animationBlock(first, second) }, completion: completion)
    }

    func animate(_ first: UIView, second: UIView, third: UIView, for duration: TimeInterval, animationBlock: @escaping (UIView, UIView, UIView) -> Void) {
        animate(first, second: second, third: third, for: duration, animationBlock: animationBlock, completion: { _ in })
    }

    func animate(_ first: UIView, second: UIView, third: UIView, for duration: TimeInterval, animationBlock: @escaping (UIView, UIView, UIView) -> Void, completion: @escaping (Bool) -> Void) {
        let complete = {
            animationBlock(first, second, third)
            completion(true)
        }

        guard first.window != nil else { return complete() }
        guard second.window != nil else { return complete() }
        guard third.window != nil else { return complete() }

        UIView.animate(withDuration: duration, animations: { animationBlock(first, second, third) }, completion: completion)
    }

}
