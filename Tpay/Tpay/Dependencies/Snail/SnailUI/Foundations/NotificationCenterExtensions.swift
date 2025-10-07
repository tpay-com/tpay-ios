//  Copyright © 2016 Compass. All rights reserved.

import Foundation

extension NotificationCenter {
    func observeEvent(_ name: Foundation.Notification.Name?, object: AnyObject? = nil) -> Observable<Foundation.Notification> {
        let observable = Observable<Foundation.Notification>()
        addObserver(forName: name, object: object, queue: nil) { notification in
            observable.on(.next(notification))
        }
        return observable
    }
}
