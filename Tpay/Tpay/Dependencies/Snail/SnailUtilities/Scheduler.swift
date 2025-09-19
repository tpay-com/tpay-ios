//  Copyright © 2018 Compass. All rights reserved.

import Foundation

class Scheduler {
    let delay: TimeInterval
    let repeats: Bool

    let observable = Observable<Void>()
    private var timer: Timer?

    init(_ delay: TimeInterval, repeats: Bool = true) {
        self.delay = delay
        self.repeats = repeats
    }

    @objc func onNext() {
        observable.on(.next(()))
    }

    func start() {
        stop()
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(onNext), userInfo: nil, repeats: repeats)
    }

    func stop() {
        timer?.invalidate()
    }
}
