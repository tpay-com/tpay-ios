//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension Invocation {
    
    final class Group {
        
        // MARK: - Properties
        
        private let retainer: Retainer
        
        private let uuid = UUID()
        private let dispatchGroup = DispatchGroup()
        
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
            method { [weak self] result in
                self?.results.append(result)
                self?.dispatchGroup.leave()
            }
            return self
        }
        
        @discardableResult
        func append<ArgumentType>(method: @escaping (ArgumentType, @escaping (Result<Void, Error>) -> Void) -> Void, with argument: ArgumentType) -> Self {
            dispatchGroup.enter()
            method(argument) { [weak self] result in
                self?.results.append(result)
                self?.dispatchGroup.leave()
            }
            return self
        }
        
        @discardableResult
        func append<FirstArgumentType, SecondArgumentType>(method: @escaping (FirstArgumentType, SecondArgumentType, @escaping (Result<Void, Error>) -> Void) -> Void, with firstArgument: FirstArgumentType, _ secondArgument: SecondArgumentType) -> Self {
            dispatchGroup.enter()
            method(firstArgument, secondArgument) { [weak self] result in
                self?.results.append(result)
                self?.dispatchGroup.leave()
            }
            return self
        }
        
        @discardableResult
        func append<FirstArgumentType, SecondArgumentType, ThirdArgumentType>(method: @escaping (FirstArgumentType, SecondArgumentType, ThirdArgumentType, @escaping (Result<Void, Error>) -> Void) -> Void, with firstArgument: FirstArgumentType, _ secondArgument: SecondArgumentType, _ thirdArgument: ThirdArgumentType) -> Self {
            dispatchGroup.enter()
            method(firstArgument, secondArgument, thirdArgument) { [weak self] result in
                self?.results.append(result)
                self?.dispatchGroup.leave()
            }
            return self
        }
        
        func invoke(completion: @escaping (Result<Void, Error>) -> Void) {
            retainer.retain(self, for: uuid)
            
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
        
    }
    
}
