//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class Invocation_Merge_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut = Invocation.Merge<Int>()
    
    // MARK: - Tests
    
    func test_GroupingRequests() {
        let methodWithoutArguments: ((Result<Int, Error>) -> Void) -> Void = { completion in completion(.success(1)) }
        let methodWithArgument: ((Int, (Result<Int, Error>) -> Void) -> Void) = { _, completion in completion(.success(2)) }
        
        sut.append(methodWithoutArguments)
        sut.append(method: methodWithArgument, with: 10)
        
        waitUntil { done in
            self.sut.invoke { results in
                done()
                
                expect(results.count) == 2
                var receivedValues: [Int] = []
                for result in results {
                    switch result {
                    case .failure: fail("Unexpected result")
                    case let .success(value): receivedValues.append(value)
                    }
                }
                
                expect(receivedValues) == [1, 2]
            }
        }
    }
    
    func test_GroupingRequestsContainsFailure() {
        let methodWithoutArguments: ((Result<Int, Error>) -> Void) -> Void = { completion in completion(.failure(Errors.fake)) }
        let methodWithArgument: ((Int, (Result<Int, Error>) -> Void) -> Void) = { _, completion in completion(.success(1)) }
        
        sut.append(methodWithoutArguments)
        sut.append(method: methodWithArgument, with: 10)
        
        waitUntil { done in
            self.sut.invoke { results in
                done()
                
                expect(results.count) == 2
                
                var receiveValuesCount = 0
                var receiveErrorCount = 0
                for result in results {
                    switch result {
                    case .failure: receiveErrorCount += 1
                    case .success: receiveValuesCount += 1
                    }
                }
                
                expect(receiveValuesCount) == 1
                expect(receiveErrorCount) == 1
            }
        }
    }
    
    func test_ObjectIsReleased() {
        weak var reference = sut
        
        expect(reference).toNot(beNil())
        
        let methodWithoutArguments: ((Result<Int, Error>) -> Void) -> Void = { completion in completion(.failure(Errors.fake)) }
        sut.append(methodWithoutArguments)
        sut = Invocation.Merge()
        
        expect(reference).to(beNil())
    }
    
    func test_InvokeWithoutMethodsAdded() {
        waitUntil { done in
            self.sut.invoke { results in
                done()
                expect(results).to(beEmpty())
            }
        }
    }
    
}

extension Invocation_Merge_Tests {
    
    private enum Errors: Error, Equatable {
        
        case fake
        
    }
    
}
