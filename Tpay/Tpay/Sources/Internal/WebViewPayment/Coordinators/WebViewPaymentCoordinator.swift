//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

final class WebViewCoordinator {
    
    // MARK: - Events
        
    let onPaymentCompleted = Observable<Void>()
    let onPaymentError = Observable<Void>()
    var onPaymentCancelled: Observable<Void> { sheetViewController.closeButtonTapped }
    
    // MARK: - Properties
    
    let sheetViewController: SheetViewController
    
    private let transaction: ExternallyGeneratedTransaction
    private let presenter: ViewControllerPresenter
    private let resolver = ModuleContainer.instance.resolver
    
    private var currentFlow: ModuleFlow? {
        didSet {
            oldValue?.stop()
            currentFlow?.start()
        }
    }
    
    // MARK: - Initialzers
    
    init(transaction: ExternallyGeneratedTransaction) {
        self.transaction = transaction
        
        sheetViewController = SheetViewController()
        presenter = ContentViewControllerPresenter(sheetViewController: sheetViewController)
    }
    
    // MARK: - API
    
    func start() {
        startPaymentFlow()
    }
    
    func stop() {
        currentFlow = nil
    }
    
    // MARK: - Private
    
    private func startPaymentFlow() {
        let paymentFlow = WebViewPaymentFlow(transaction: transaction,
                                             presenter: presenter,
                                             resolver: resolver)
        
        paymentFlow.paymentCompleted
            .forward(to: onPaymentCompleted)
        
        paymentFlow.paymentError
            .forward(to: onPaymentError)
        
        currentFlow = paymentFlow
    }
}
