//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultFailureViewModel: FailureViewModel {
    
    // MARK: - Properties

    let content: FailureContent
    
    private let router: FailureRouter
    
    // MARK: - Initializers

    init(content: FailureContent, router: FailureRouter) {
        self.content = content
        self.router = router
    }
    
    // MARK: - API

    func primaryAction() {
        router.invokeOnPrimaryAction()
    }
    
    func cancel() {
        router.invokeOnCancel()
    }
}
