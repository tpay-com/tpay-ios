//  Copyright © 2017 Compass. All rights reserved.

import Foundation

class Subscriber<T>: DisposableType {
    let queue: DispatchQueue?
    let handler: (Event<T>) -> Void
    private(set) weak var observable: Observable<T>?

    init(queue: DispatchQueue?, observable: Observable<T>, handler: @escaping (Event<T>) -> Void) {
        self.queue = queue
        self.handler = handler
        self.observable = observable
    }

    func dispose() {
        observable?.removeSubscriber(subscriber: self)
    }

    func add(to disposer: Disposer) {
        disposer.add(disposable: self)
    }
}
