//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension Invocation {
    
    final class Queue {
        
        // MARK: - Properties
        
        private let retainer: Retainer
        
        private let uuid = UUID()
        private let dispatchGroup = DispatchGroup()
        
        private var methodsToInvoke: [() -> Void] = []
        private var results: [Result<Void, Error>] = []
        
        // MARK: - Initializers
        
        convenience init() {
            self.init(retainer: .instance)
        }
        
        init(retainer: Invocation.Retainer) {
            self.retainer = retainer
        }
        
        // MARK: - API
        
        @discardableResult
        func append(_ method: @escaping (@escaping (Result<Void, Error>) -> Void) -> Void) -> Self {
            dispatchGroup.enter()
            methodsToInvoke.append { [weak self] in
                method { result in
                    self?.results.append(result)
                    self?.dispatchGroup.leave()
                    
                    self?.invokeNextMethod()
                }
            }
            return self
        }
        
        @discardableResult
        func append<ArgumentType>(method: @escaping (ArgumentType, @escaping (Result<Void, Error>) -> Void) -> Void, with argument: ArgumentType) -> Self {
            dispatchGroup.enter()
            methodsToInvoke.append { [weak self] in
                method(argument) { result in
                    self?.results.append(result)
                    self?.dispatchGroup.leave()
                    
                    self?.invokeNextMethod()
                }
            }
            return self
        }
        
        @discardableResult
        func append<FirstArgumentType, SecondArgumentType>(method: @escaping (FirstArgumentType, SecondArgumentType, @escaping (Result<Void, Error>) -> Void) -> Void, with firstArgument: FirstArgumentType, _ secondArgument: SecondArgumentType) -> Self {
            dispatchGroup.enter()
            methodsToInvoke.append { [weak self] in
                method(firstArgument, secondArgument) { result in
                    self?.results.append(result)
                    self?.dispatchGroup.leave()
                    
                    self?.invokeNextMethod()
                }
            }
            return self
        }
        
        @discardableResult
        func append<FirstArgumentType, SecondArgumentType, ThirdArgumentType>(method: @escaping (FirstArgumentType, SecondArgumentType, ThirdArgumentType, @escaping (Result<Void, Error>) -> Void) -> Void, with firstArgument: FirstArgumentType, _ secondArgument: SecondArgumentType, _ thirdArgument: ThirdArgumentType) -> Self {
            dispatchGroup.enter()
            methodsToInvoke.append { [weak self] in
                method(firstArgument, secondArgument, thirdArgument) { result in
                    self?.results.append(result)
                    self?.dispatchGroup.leave()
                    
                    self?.invokeNextMethod()
                }
            }
            return self
        }
        
        func invoke(completion: @escaping (Result<Void, Error>) -> Void) {
            retainer.retain(self, for: uuid)
            
            invokeNextMethod()
            
            dispatchGroup.notify(queue: .main) { [weak self, retainer, uuid] in
                defer { retainer.releaseObject(with: uuid) }
                
                guard let results = self?.results, results.isNotEmpty else {
                    if Target.current == .develop { assertionFailure() }
                    return completion(.failure(Errors.completedWithoutResults))
                }
                
                do {
                    try results.forEach { result in try result.get() }
                } catch {
                    return completion(.failure(error))
                }
                completion(.success(()))
            }
        }
        
        // MARK: - Methods
        
        private func invokeNextMethod() {
            guard results.count < methodsToInvoke.count else { return }
            
            if case .failure = results.last {
                return (0 ..< methodsToInvoke.count - results.count).forEach { _ in dispatchGroup.leave() }
            }
            
            methodsToInvoke[results.count]()
        }
        
    }
    
}
