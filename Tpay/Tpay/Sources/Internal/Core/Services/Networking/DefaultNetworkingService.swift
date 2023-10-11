//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultNetworkingService: NetworkingService {
    
    // MARK: - Properties
    
    private let requestFactory: RequestFactory
    private let session: Session
    private let errorValidator: ErrorValidator
    private let responseValidator: ResponseValidator
    private let bodyDecoder: BodyDecoder
    
    private let queue = DispatchQueue.global(qos: .userInitiated)
    
    // MARK: - Initializers
    
    init(requestFactory: RequestFactory,
         session: Session,
         errorValidator: ErrorValidator,
         responseValidator: ResponseValidator,
         bodyDecoder: BodyDecoder) {
        self.requestFactory = requestFactory
        self.session = session
        self.errorValidator = errorValidator
        self.responseValidator = responseValidator
        self.bodyDecoder = bodyDecoder
    }
    
    // MARK: - API
    
    func execute<RequestType: NetworkRequest, ResponseType>(request: RequestType) -> NetworkRequestResult<ResponseType> where ResponseType == RequestType.ResponseType {
        let requestResult = NetworkRequestResult<ResponseType>()
        queue.async { [weak self] in self?.execute(request: request, for: requestResult) }
        return requestResult
    }
    
    // MARK: - Private
    
    private func execute<RequestType: NetworkRequest, ResponseType>(request: RequestType, for result: NetworkRequestResult<ResponseType>) where ResponseType == RequestType.ResponseType {
        let urlRequest = requestFactory.request(for: request)
        Logger.request(urlRequest)
                
        result.networkTask = session.invoke(request: urlRequest) { [errorValidator, responseValidator, bodyDecoder] data, response, error in
            Logger.response(data, response, error)
            
            do {
                try errorValidator.validate(error: error)
                try responseValidator.validate(response: response, with: data)
                
                guard let data = data else {
                    preconditionFailure("Response validator should handle this case!")
                }
                
                result.handle(success: try bodyDecoder.decode(body: data))
            } catch {
                result.handle(error: error)
            }
        }
    }
}
