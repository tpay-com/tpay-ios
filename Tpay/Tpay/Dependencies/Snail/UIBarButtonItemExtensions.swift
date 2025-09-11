//  Copyright © 2016 Compass. All rights reserved.

#if os(iOS) || os(tvOS)
import UIKit

extension UIBarButtonItem {
    private static let observableKey = "com.compass.Snail.UIBarButtonItem.ObservableKey"

    private var tapObservable: Observable<Void> {
        if let observable = objc_getAssociatedObject(self, UIBarButtonItem.observableKey.pointer) as? Observable<Void> {
            return observable
        }
        let observable = Observable<Void>()
        objc_setAssociatedObject(self, UIBarButtonItem.observableKey.pointer, observable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return observable
    }

    var tap: Observable<Void> {
        target = self
        action = #selector(observableHandler(_:))
        return tapObservable
    }

    @objc private func observableHandler(_ sender: UIBarButtonItem) {
        tapObservable.on(.next(()))
    }
}

#endif
