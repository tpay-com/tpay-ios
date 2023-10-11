//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultSession: Session {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let taskMapper: (URLSessionTask) -> NetworkTask
    
    // MARK: - Initializers
    
    convenience init() {
        self.init(using: .shared, taskMapper: DefaultNetworkTask.init)
    }
    
    init(using session: URLSession, taskMapper: @escaping (URLSessionTask) -> NetworkTask) {
        self.session = session
        self.taskMapper = taskMapper
    }
    
    // MARK: - API
    
    func invoke(request: URLRequest, then: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        let task = session.dataTask(with: request, completionHandler: then)
        task.resume()
        return taskMapper(task)
    }
}
