//  Copyright © 2019 Compass. All rights reserved.

import Foundation

class Closure<T>: DisposableType {
    private(set) var closure: T?

    init(_ closure: T) {
        self.closure = closure
    }

    func dispose() {
        closure = nil
    }

    func add(to disposer: Disposer) -> Closure<T> {
        disposer.add(disposable: self)
        return self
    }
}
