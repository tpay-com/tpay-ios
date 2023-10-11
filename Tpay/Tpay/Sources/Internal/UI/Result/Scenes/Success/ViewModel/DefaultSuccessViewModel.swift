//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultSuccessViewModel: SuccessViewModel {
    
    // MARK: - Properties
    
    let content: SuccessContent
    
    private let router: SuccessRouter
    
    // MARK: - Initializers

    init(content: SuccessContent, router: SuccessRouter) {
        self.content = content
        self.router = router
    }
    
    // MARK: - API
    
    func proceed() {
        router.invokeOnProceed()
    }
}
