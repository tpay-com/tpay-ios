//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class NetworkRequestResult<ResponseType: Decodable> {
    
    // MARK: - Properties
    
    weak var networkTask: NetworkTask?
    
    private var successHandler: ((ResponseType) -> Void)?
    private var errorHandler: ((Error) -> Void)?
    private var resultHandler: ((Result<ResponseType, Error>) -> Void)?
    private var cancelHandler: (() -> Void)?
    private var thenHandler: Completion?
    
    // MARK: - Lifecycle
    
    deinit {
        cancelTask()
    }

    // MARK: - API
    
    @discardableResult
    func onSuccess(_ handler: @escaping (ResponseType) -> Void) -> Self {
        successHandler = handler
        return self
    }
    
    @discardableResult
    func onError(_ handler: @escaping (Error) -> Void) -> Self {
        errorHandler = handler
        return self
    }
    
    @discardableResult
    func onResult(_ handler: @escaping (Result<ResponseType, Error>) -> Void) -> Self {
        resultHandler = handler
        return self
    }
    
    @discardableResult
    func onCancel(_ handler: @escaping () -> Void) -> Self {
        cancelHandler = handler
        return self
    }
    
    @discardableResult
    func then(_ handler: @escaping Completion) -> Self {
        thenHandler = handler
        return self
    }
    
    func handle(success object: ResponseType) {
        successHandler?(object)
        resultHandler?(.success(object))
        thenHandler?(.success(()))
    }
    
    func handle(error: Error) {
        errorHandler?(error)
        resultHandler?(.failure(error))
        thenHandler?(.failure(error))
    }
    
    func cancelTask() {
        networkTask?.cancel()
        cancelHandler?()
    }
}
