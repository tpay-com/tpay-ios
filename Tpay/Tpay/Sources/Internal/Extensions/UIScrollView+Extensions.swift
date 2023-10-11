//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    private static var contentOffsetObservationTokenKey = "com.tpay.sdk.UIScrollView.ContentOffsetObservationTokenKey"
    private static var contentOffsetObservableKey = "com.tpay.sdk.UIScrollView.ContentOffsetObservableKey"
    
    private var contentOffsetObservationToken: NSKeyValueObservation {
        if let observationToken = objc_getAssociatedObject(self, &UIScrollView.contentOffsetObservationTokenKey) as? NSKeyValueObservation {
            return observationToken
        }
        let observationToken = observe(\.contentOffset, options: .new) { [weak self] _, change in
            guard let newValue = change.newValue else {
                return
            }
            self?.contentOffsetObservable.on(.next(newValue))
        }
        objc_setAssociatedObject(self, &UIScrollView.contentOffsetObservationTokenKey, observationToken, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return observationToken
    }
    
    private var _contentOffsetObservable: Observable<CGPoint> {
        if let observable = objc_getAssociatedObject(self, &UIScrollView.contentOffsetObservableKey) as? Observable<CGPoint> {
            return observable
        }
        let observable = Observable<CGPoint>()
        objc_setAssociatedObject(self, &UIScrollView.contentOffsetObservableKey, observable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return observable
    }
    
    var contentOffsetObservable: Observable<CGPoint> {
        _ = contentOffsetObservationToken
        return _contentOffsetObservable
    }
}

extension UIScrollView {
    
    private static var contentSizeObservationTokenKey = "com.tpay.sdk.UIScrollView.ContentSizeObservationTokenKey"
    private static var contentSizeObservableKey = "com.tpay.sdk.UIScrollView.ContentSizeObservableKey"
    
    private var contentSizeObservationToken: NSKeyValueObservation {
        if let observationToken = objc_getAssociatedObject(self, &UIScrollView.contentSizeObservableKey) as? NSKeyValueObservation {
            return observationToken
        }
        let observationToken = observe(\.contentSize, options: .new) { [weak self] _, change in
            guard let newValue = change.newValue else {
                return
            }
            self?.contentSizeObservable.on(.next(newValue))
        }
        objc_setAssociatedObject(self, &UIScrollView.contentSizeObservationTokenKey, observationToken, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return observationToken
    }
    
    private var _contentSizeObservable: Observable<CGSize> {
        if let observable = objc_getAssociatedObject(self, &UIScrollView.contentSizeObservableKey) as? Observable<CGSize> {
            return observable
        }
        let observable = Observable<CGSize>()
        objc_setAssociatedObject(self, &UIScrollView.contentSizeObservableKey, observable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return observable
    }
    
    var contentSizeObservable: Observable<CGSize> {
        _ = contentSizeObservationToken
        return _contentSizeObservable
    }
}
