//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class DefaultFeedbackGenerator: FeedbackGenerator {
    
    // MARK: - API
    
    func generateFeedback(type: FeedbackType) {
        switch type {
        case .success:
            generateSuccessFeedback()
        case .failure:
            generateFailureFeedback()
        }
    }
    
    // MARK: - Private
    
    private func generateSuccessFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    private func generateFailureFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}
