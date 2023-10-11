//  Copyright © 2016 Compass. All rights reserved.

#if os(iOS) || os(tvOS)
import UIKit

extension UIControl {
    private static var observableKey = "com.compass.Snail.UIControl.ObservableKey"

    func controlEvent(_ controlEvents: UIControl.Event) -> Observable<Void> {
        if let observable = objc_getAssociatedObject(self, &UIControl.observableKey) as? Observable<Void> {
            return observable
        }
        let observable = Observable<Void>()
        objc_setAssociatedObject(self, &UIControl.observableKey, observable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(observableHandler(_:)), for: controlEvents)
        return observable
    }

    @objc private func observableHandler(_ sender: UIControl) {
        if let observable = objc_getAssociatedObject(self, &UIControl.observableKey) as? Observable<Void> {
            observable.on(.next(()))
        }
    }
}

#endif
