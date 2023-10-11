//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Observable {
    
    func skip(until conditionIsMet: @escaping ((T) -> Bool)) -> Observable<T> {
        let observable = Observable<T>()
        var wasConditionFulfilled = false

        _ = subscribe(onNext: {
            if wasConditionFulfilled {
                observable.on(.next($0))
                return
            }
            guard conditionIsMet($0) else {
                return
            }
            wasConditionFulfilled = true
            observable.on(.next($0))
        }, onError: {
            observable.on(.error($0))
        }, onDone: {
            observable.on(.done)
        })
        return observable
    }
    
    // swiftlint:disable force_unwrapping
    func unwrap<U>() -> Observable<U> where T == U? {
        self
            .filter { $0 != nil }
            .map { $0! }
    }
}
