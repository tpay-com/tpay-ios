//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

final class AddCardFlow: ModuleFlow {
 
    // MARK: - Events
    
    let titleImage = Observable<UIImage?>()
    
    let tokenizationCompleted = Observable<Void>()
    let tokenizationCancelled = Observable<Void>()
    let retry = Observable<Void>()
    
    // MARK: - Properties
    
    private let presenter: ViewControllerPresenter
    private let screenManager: ScreenManager
    private let addCardScreen: AddCardScreen
    private let resolver: ServiceResolver
    
    private let payer: Payer?
    
    private let deviceAccessoryInteractor = DefaultDeviceAccessoryInteractor()
    private let disposer = Disposer()
    
    private var currentFlow: ModuleFlow? {
        didSet {
            oldValue?.stop()
            currentFlow?.start()
        }
    }
    
    // MARK: - Initializers
    
    init(with presenter: ViewControllerPresenter, using resolver: ServiceResolver, payer: Payer?) {
        self.presenter = presenter
        self.resolver = resolver
        self.payer = payer
        
        screenManager = ScreenManager(presenter: presenter)
        addCardScreen = AddCardScreen(payer: payer, resolver: resolver)
    }
    
    deinit {
        Logger.debug("deinit from: \(self)")
    }
    
    // MARK: - API
    
    func start() {
        showAddCardScreen()
    }
    
    func stop() {
        currentFlow = nil
    }
    
    // MARK: - Private
    
    private func showAddCardScreen() {
        titleImage.on(.next(UIImage(asset: Asset.Icons.card)))
        
        addCardScreen.router.onCardScan
            .subscribe(queue: .main, onNext: { [weak self] in self?.handleStartCardScanning() })
            .add(to: disposer)
        
        addCardScreen.router.onSuccess
            .subscribe(queue: .main, onNext: { [weak self] tokenization in self?.handleAddCardResponse(tokenization) })
            .add(to: disposer)
            
        addCardScreen.router.onError
            .subscribe(queue: .main, onNext: { [weak self] _ in self?.showAddCardFailureScreen() })
            .add(to: disposer)
            
        screenManager.show(addCardScreen)
    }
    
    private func showProcessingPaymentScreen(for tokenization: Domain.OngoingTokenization) {
        let screen = ProcessingTokenizationWithUrlScreen(for: tokenization, using: resolver)
        
        screen.router.onSuccess
            .subscribe(queue: .main, onNext: { [weak self] in self?.showAddCardSuccessScreen() })
            .add(to: disposer)
        
        screen.router.onError
            .subscribe(queue: .main, onNext: { [weak self] in self?.showAddCardFailureScreen() })
            .add(to: disposer)
        
        screenManager.show(screen)
    }
    
    private func handleAddCardResponse(_ tokenization: Domain.OngoingTokenization) {
        guard tokenization.continueUrl != nil else {
            showAddCardSuccessScreen()
            return
        }
        showProcessingPaymentScreen(for: tokenization)
    }
    
    private func handleStartCardScanning() {
        guard #available(iOS 13.0, *) else { return }
        deviceAccessoryInteractor.setupCameraAccessory { [weak self] result in
            switch result {
            case .success: self?.presentCardScanningScreen()
            case .failure: self?.presentNoCameraAccessDialog()
            }
        }
    }
    
    private func showAddCardSuccessScreen() {
        let successContent = SuccessContent(title: Strings.tokenizationSuccessTitle,
                                            buttonTitle: Strings.ok,
                                            description: Strings.tokenizationSuccessDescription)
        let screen = SuccessScreen(content: successContent)
        
        screen.router.onProceed
            .forward(to: tokenizationCompleted)
        
        screenManager.show(screen)
    }
    
    private func showAddCardFailureScreen() {
        let failureContent = FailureContent(title: Strings.tokenizationFailureTitle,
                                            primaryButtonTitle: Strings.tryAgain,
                                            description: Strings.tokenizationFailureDescription,
                                            linkButtonTitle: Strings.cancel)
        let failureScreen = FailureScreen(content: failureContent)
        
        failureScreen.router.onCancel
            .forward(to: tokenizationCancelled)
        
        failureScreen.router.onPrimaryAction
            .subscribe(onNext: { [weak self, unowned addCardScreen] _ in
                self?.screenManager.show(addCardScreen)
            })
            .add(to: disposer)
        
        screenManager.show(failureScreen)
    }
    
    @available(iOS 13.0, *)
    private func presentCardScanningScreen() {
        let cardScreen = CardScanningScreen()
        
        cardScreen.router.completeAction
            .subscribe(onNext: { [weak self, unowned cardScreen] data in
                self?.addCardScreen.set(cardData: data)
                self?.screenManager.dismiss(cardScreen)
            })
            .add(to: disposer)

        cardScreen.router.closeAction
            .subscribe(onNext: { [weak self, unowned cardScreen] in
                self?.screenManager.dismiss(cardScreen)
            })
            .add(to: disposer)
        
        screenManager.presentFullScreen(cardScreen)
    }
    
    private func presentNoCameraAccessDialog() {
        screenManager.presentNoCameraAccessDialog()
    }
}
