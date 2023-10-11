//
//  Copyright © 2022 Tpay. All rights reserved.
//

class Poller<Request: NetworkRequest> {
    
    // MARK: - Events
    
    let result = Observable<Result<Request.ResponseType, Error>>()
    
    // MARK: - Properties
    
    private let request: Request
    private let networkingService: NetworkingService
    
    private var repeater: Repeater?
    private var ongoingRequest: NetworkRequestResult<Request.ResponseType>?
    
    // MARK: - Initializers
    
    init(for request: Request, using networkingService: NetworkingService) {
        self.request = request
        self.networkingService = networkingService
    }
    
    // MARK: - API
    
    func startPolling(every: DispatchTimeInterval = .defaultPollingInterval) {
        repeater = Repeater(timeInterval: every)
        repeater?.notify(on: self) { poller in
            poller.fireRequest()
        }
        fireRequest()
        repeater?.start()
    }
    
    func cancel() {
        repeater?.suspend()
        ongoingRequest?.cancelTask()
        ongoingRequest = nil
    }
    
    // MARK: - Private
    
    private func fireRequest() {
        ongoingRequest = networkingService.execute(request: request)
            .onResult { [weak self] result in self?.result.on(.next(result)) }
    }
}

private extension DispatchTimeInterval {
    
    static let defaultPollingInterval = DispatchTimeInterval.seconds(2)
}
