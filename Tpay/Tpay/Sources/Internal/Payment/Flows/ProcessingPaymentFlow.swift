//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class ProcessingPaymentFlow: ModuleFlow {
    
    // MARK: - Events
    
    let paymentCompleted = Observable<Void>()
    let paymentCancelled = Observable<Void>()
    let retry = Observable<Void>()
        
    // MARK: - Properties
    
    private let ongoingTransaction: Domain.OngoingTransaction
    private let presenter: ViewControllerPresenter
    private let resolver: ServiceResolver
    private let screenManager: ScreenManager
    
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    init(ongoingTransaction: Domain.OngoingTransaction, presenter: ViewControllerPresenter, resolver: ServiceResolver) {
        self.ongoingTransaction = ongoingTransaction
        self.presenter = presenter
        self.resolver = resolver
        
        screenManager = ScreenManager(presenter: presenter)
    }
    
    deinit {
        Logger.debug("deinit from: \(self)")
    }
    
    // MARK: - API
    
    func start() {
        Logger.info("Processing \(ongoingTransaction)")
        if ongoingTransaction.continueUrl != nil {
            startProcessingWithContinueUrl()
        } else {
            startProcessingWithoutContinueUrl()
        }
    }
    
    func stop() { }
    
    // MARK: - Private
    
    private func startProcessingWithContinueUrl() {
        showProcessingPaymentWithUrlScreen()
    }
    
    private func startProcessingWithoutContinueUrl() {
        switch ongoingTransaction.status {
        case .correct:
            showPaymentSuccessScreen()
        case .error:
            showPaymentErrorScreen()
        default:
            showProcessingPaymentScreen()
        }
    }
    
    private func showProcessingPaymentWithUrlScreen() {
        let screen = ProcessingPaymentWithUrlScreen(for: ongoingTransaction, using: resolver)
        
        screen.router.onSuccess
            .subscribe(queue: .main, onNext: { [weak self] in self?.showPaymentSuccessScreen() })
            .add(to: disposer)
        
        screen.router.onError
            .subscribe(queue: .main, onNext: { [weak self] in self?.showPaymentErrorScreen() })
            .add(to: disposer)
        
        screenManager.show(screen)
    }

    private func showProcessingPaymentScreen() {
        let screen = ProcessingPaymentScreen(for: ongoingTransaction, using: resolver)
        
        screen.router.onSuccess
            .subscribe(queue: .main, onNext: { [weak self] in self?.showPaymentSuccessScreen() })
            .add(to: disposer)
        
        screen.router.onError
            .subscribe(queue: .main, onNext: { [weak self] in self?.showPaymentErrorScreen() })
            .add(to: disposer)
        
        screenManager.show(screen)
    }
    
    private func showPaymentSuccessScreen() {
        let successContent = SuccessContent(title: Strings.paymentSuccessTitle,
                                            buttonTitle: Strings.paymentSuccessButtonTitle,
                                            description: nil)
        let screen = SuccessScreen(content: successContent)
        
        screen.router.onProceed
            .forward(to: paymentCompleted)
        
        screenManager.show(screen)
    }
    
    private func showPaymentErrorScreen() {
        let failureContent = FailureContent(title: Strings.paymentFailureTitle,
                                            primaryButtonTitle: Strings.paymentFailureButtonTitle,
                                            description: nil,
                                            linkButtonTitle: Strings.cancel)
        let screen = FailureScreen(content: failureContent)
        
        screen.router.onCancel
            .forward(to: paymentCancelled)
        
        screen.router.onPrimaryAction
            .forward(to: retry)
        
        screenManager.show(screen)
    }
}
