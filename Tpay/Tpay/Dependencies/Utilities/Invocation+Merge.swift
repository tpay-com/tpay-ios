//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension Invocation {
    
    final class Merge<ObjectType> {
        
        // MARK: - Properties
        
        private let retainer: Retainer
        
        private let uuid = UUID()
        private let dispatchGroup = DispatchGroup()
        
        private var results: [Result<ObjectType, Error>] = []
        
        // MARK: - Initializers
        
        convenience init() {
            self.init(using: .instance)
        }
        
        init(using retainer: Retainer) {
            self.retainer = retainer
        }
        
        // MARK: - API
        
        @discardableResult
        func append(_ method: @escaping (@escaping (Result<ObjectType, Error>) -> Void) -> Void) -> Self {
            dispatchGroup.enter()
            method { [weak self] result in
                self?.results.append(result)
                self?.dispatchGroup.leave()
            }
            return self
        }
        
        @discardableResult
        func append<ArgumentType>(method: @escaping (ArgumentType, @escaping (Result<ObjectType, Error>) -> Void) -> Void, with argument: ArgumentType) -> Self {
            dispatchGroup.enter()
            method(argument) { [weak self] result in
                self?.results.append(result)
                self?.dispatchGroup.leave()
            }
            return self
        }
        
        func invoke(completion: @escaping ([Result<ObjectType, Error>]) -> Void) {
            defer { retainer.retain(self, for: uuid) }
            
            dispatchGroup.notify(queue: .main) { [weak self, retainer, uuid] in
                defer { retainer.releaseObject(with: uuid) }
                
                guard let results = self?.results else {
                    if Target.current == .develop { assertionFailure() }
                    return completion([.failure(Errors.completedWithoutResults)])
                }
                
                completion(results)
            }
        }
        
    }
    
}
