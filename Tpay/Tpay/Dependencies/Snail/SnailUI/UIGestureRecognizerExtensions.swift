//  Copyright © 2016 Compass. All rights reserved.

#if os(iOS) || os(tvOS)
import UIKit

extension UIGestureRecognizer {
    private static var observableKey = "com.compass.Snail.UIGestureRecognizer.ObservableKey"

    func asObservable() -> Observable<UIGestureRecognizer> {
        if let observable = objc_getAssociatedObject(self, UIGestureRecognizer.observableKey.pointer) as? Observable<UIGestureRecognizer> {
            return observable
        }
        let observable = Observable<UIGestureRecognizer>()
        objc_setAssociatedObject(self, UIGestureRecognizer.observableKey.pointer, observable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(observableHandler))
        return observable
    }

    @objc private func observableHandler(_ sender: UIGestureRecognizer) {
        if let observable = objc_getAssociatedObject(self, UIGestureRecognizer.observableKey.pointer) as? Observable<UIGestureRecognizer> {
            observable.on(.next(sender))
        }
    }
}

#endif
