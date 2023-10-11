//  Copyright © 2019 Compass. All rights reserved.

import Foundation

protocol DisposableType {
    func dispose()
}

class Disposer {
    private(set) var disposables: [DisposableType] = []
    private let recursiveLock = NSRecursiveLock()

    init() {}

    deinit {
        disposeAll()
    }

    func disposeAll() {
        recursiveLock.lock(); defer { recursiveLock.unlock() }
        disposables.forEach { $0.dispose() }
        disposables.removeAll()
    }

    func add(disposable: DisposableType) {
        recursiveLock.lock(); defer { recursiveLock.unlock() }
        disposables.append(disposable)
    }
}
