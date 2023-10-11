//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class Invocation_Queue_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut = Invocation.Queue()
    
    // MARK: - Tests
    
    func test_GroupingRequests() {
        let methodWithoutArguments: ((Result<Void, Error>) -> Void) -> Void = { completion in completion(.success(())) }
        let methodWithArgument: ((Int, (Result<Void, Error>) -> Void) -> Void) = { _, completion in completion(.success(())) }
        let methodWithTwoArgument: ((Int, Int, (Result<Void, Error>) -> Void) -> Void) = { _, _, completion in completion(.success(())) }
        let methodWithThreeArgument: ((Int, Int, Int, (Result<Void, Error>) -> Void) -> Void) = { _, _, _, completion in completion(.success(())) }
        
        sut.append(methodWithoutArguments)
        sut.append(method: methodWithArgument, with: 10)
        sut.append(method: methodWithTwoArgument, with: 10, 20)
        sut.append(method: methodWithThreeArgument, with: 10, 20, 30)
        
        waitUntil { done in
            self.sut.invoke { result in
                done()
                
                switch result {
                case .success: break
                case .failure: fail("Invalid result")
                }
            }
        }
    }
    
    func test_GroupingRequestsContainsFailure() {
        let methodWithoutArguments: ((Result<Void, Error>) -> Void) -> Void = { completion in completion(.failure(Errors.fake)) }
        let methodWithArgument: ((Int, (Result<Void, Error>) -> Void) -> Void) = { _, completion in completion(.success(())) }
        
        sut.append(methodWithoutArguments)
        sut.append(method: methodWithArgument, with: 10)
        
        waitUntil { done in
            self.sut.invoke { result in
                done()
                
                switch result {
                case .success: fail("Invalid result")
                case let .failure(error): expect(error as? Errors) == Errors.fake
                }
            }
        }
    }
    
    func test_ObjectIsReleased() {
        weak var reference = sut
        
        expect(reference).toNot(beNil())
        
        let methodWithoutArguments: ((Result<Void, Error>) -> Void) -> Void = { completion in completion(.failure(Errors.fake)) }
        sut.append(methodWithoutArguments)
        sut = Invocation.Queue()
        
        expect(reference).to(beNil())
    }
    
    func test_InvokeWithoutMethodsAdded() {
        waitUntil { done in
            self.sut.invoke { result in
                done()
                
                switch result {
                case let .failure(error): expect(error as? Invocation.Errors) == .completedWithoutResults
                case .success: fail("Unexpected state")
                }
            }
        }
    }
    
}

extension Invocation_Queue_Tests {
    
    private enum Errors: Error, Equatable {
        
        case fake
        
    }
    
}
