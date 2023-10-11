//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class ObservableExtensions_Tests: XCTestCase {

    // MARK: - Properties
    
    private var subject: Observable<String>?
    private var strings: [String]?
    private var error: Error?
    private var done: Bool?
    private let disposer = Disposer()
    
    // MARK: - Overrides
    
    override func setUp() {
        super.setUp()
        subject = Observable()
        strings = []
        error = nil
        done = nil
        subject?.subscribe(
            onNext: { string in self.strings?.append(string) },
            onError: { error in self.error = error },
            onDone: { self.done = true }).add(to: disposer)
    }
    
    // MARK: - Tests
    
    // MARK: SkipUntil
    
    func testSkipUntil() {
        let observable = Observable<String>()
        var received: [String] = []

        observable.skip(until: { $0 == "3" }).subscribe(onNext: { received.append($0) }).add(to: disposer)

        observable.on(.next("1"))
        observable.on(.next("2"))
        observable.on(.next("3"))
        observable.on(.next("4"))
        
        expect(received.count) == 2
        expect(received.first) == "3"
    }

    func testSkipUntilError() {
        let observable = Observable<String>()

        var error: MockError?
        observable.skip(until: { $0 == "3" }).subscribe(onError: { error = $0 as? MockError }).add(to: disposer)
        observable.on(.error(MockError.error))

        expect(error) == MockError.error
    }

    func testSkipUntilDone() {
        let observable = Observable<String>()
        var done = false

        observable.skip(until: { $0 == "3" }).subscribe(onDone: { done = true }).add(to: disposer)
        observable.on(.done)

        expect(done) == true
    }
    
    // MARK: Unwrap
    
    func testUnwrap() {
        let observable = Observable<String?>()
        var received: [String] = []

        observable.unwrap().subscribe(onNext: { received.append($0) }).add(to: disposer)
        observable.on(.next("1"))
        observable.on(.next(nil))
        observable.on(.next("3"))
        observable.on(.next("4"))
        
        expect(received.count) == 3
        expect(received) == ["1", "3", "4"]
    }
}

private extension ObservableExtensions_Tests {
    
    enum MockError: Error {
        
        // MARK: - Cases
        
        case error
    }
}
