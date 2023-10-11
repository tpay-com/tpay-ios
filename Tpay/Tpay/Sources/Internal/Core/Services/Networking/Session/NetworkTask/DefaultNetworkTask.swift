//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultNetworkTask: NetworkTask {
    
    // MARK: - Properties
    
    private let urlTask: URLSessionTask
    
    // MARK: - Initializers
    
    init(wrapping task: URLSessionTask) {
        urlTask = task
    }
    
    // MARK: - API
    
    func cancel() {
        urlTask.cancel()
    }
}
