//  Copyright © 2021 Compass. All rights reserved.

import Combine
import Foundation

@available(iOS 13.0, *)
class SnailPublisher<Upstream: ObservableType>: Publisher {
    typealias Output = Upstream.T
    typealias Failure = Error

    private let upstream: Upstream

    init(upstream: Upstream) {
        self.upstream = upstream
    }

    func receive<S: Combine.Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
        subscriber.receive(subscription: SnailSubscription(upstream: upstream,
                                                           downstream: subscriber))
    }
}
