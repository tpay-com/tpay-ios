//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class CardTokenPaymentCoordinator {
    
    // MARK: - Events
    
    var closeModule: Observable<Void> { sheetViewController.closeButtonTapped }
    let paymentCompleted = Observable<TransactionId>()
    let paymentFailed = Observable<TransactionId>()
    let errorOccured = Observable<ModuleError>()
    
    // MARK: - Properties
    
    let sheetViewController: SheetViewController
    
    private let transaction: Transaction
    private let presenter: ViewControllerPresenter
    private let resolver = ModuleContainer.instance.resolver
    
    private var currentFlow: ModuleFlow? {
        didSet {
            oldValue?.stop()
            currentFlow?.start()
        }
    }
    
    private var disposer = Disposer()
    
    // MARK: - Initializers
    
    init(transaction: Transaction) {
        self.transaction = transaction
        
        sheetViewController = SheetViewController()
        presenter = ContentViewControllerPresenter(sheetViewController: sheetViewController)
    }
    
    deinit {
        Logger.debug("deinit from: \(self)")
    }
    
    func start() {
        startCardTokenPaymentFlow()
    }
    
    func stop() {
        currentFlow = nil
    }
    
    // MARK: - Private

    private func startCardTokenPaymentFlow() {
        let cardTokenPaymentFlow = CardTokenPaymentFlow(for: transaction, with: presenter, using: resolver)
        
        cardTokenPaymentFlow.paymentCompleted
            .forward(to: paymentCompleted)
        
        cardTokenPaymentFlow.paymentFailed
            .forward(to: paymentFailed)
        
        cardTokenPaymentFlow.errorOcurred
            .forward(to: errorOccured)
        
        currentFlow = cardTokenPaymentFlow
    }
}
