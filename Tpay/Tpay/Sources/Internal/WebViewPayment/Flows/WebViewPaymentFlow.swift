//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

final class WebViewPaymentFlow: ModuleFlow {
    
    // MARK: - Events
    
    let paymentCompleted = Observable<Void>()
    let paymentError = Observable<Void>()
        
    // MARK: - Properties
    
    private let transaction: ExternallyGeneratedTransaction
    private let presenter: ViewControllerPresenter
    private let resolver: ServiceResolver
    private let screenManager: ScreenManager
    
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    init(transaction: ExternallyGeneratedTransaction,
         presenter: ViewControllerPresenter,
         resolver: ServiceResolver) {
        self.transaction = transaction
        self.presenter = presenter
        self.resolver = resolver
        
        screenManager = ScreenManager(presenter: presenter)
    }
    
    deinit {
        Logger.debug("deinit from: \(self)")
    }
    
    // MARK: - API
    
    func start() {
        Logger.info("Processing \(transaction)")
        showProcessExternallyGeneratedTransactionScreen()
    }
    
    func stop() { }
    
    // MARK: - Private
    
    private func showProcessExternallyGeneratedTransactionScreen() {
        let screen = ProcessExternallyGeneratedTransactionScreen(for: transaction)
        
        screen.router.onSuccess
            .forward(to: paymentCompleted)
        
        screen.router.onError
            .forward(to: paymentError)
        
        screenManager.show(screen)
    }
}
