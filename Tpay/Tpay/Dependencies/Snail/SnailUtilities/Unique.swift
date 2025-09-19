//  Copyright © 2017 Compass. All rights reserved.

class Unique<T: Equatable>: Variable<T> {
    override var value: T {
        get {
            lock.lock(); defer { lock.unlock() }
            return currentValue
        }
        set {
            guard currentValue != newValue else {
                return
            }
            lock.lock()
            currentValue = newValue
            lock.unlock()

            subject.on(.next(newValue))
        }
    }

    override init(_ value: T) {
        super.init(value)
        subject.on(.next(value))
    }
}
