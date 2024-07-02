//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class SetupPaymentFlow: ModuleFlow {
    
    // MARK: - Events
    
    let showPayerDetails = Observable<Domain.Payer>()
    let showLanguageSwitch = Observable<Void>()
    
    let transactionCreated = Observable<Domain.OngoingTransaction>()
    let errorOcurred = Observable<Error>()
    
    // MARK: - Properties
    
    private let transaction: Transaction
    private let presenter: ViewControllerPresenter
    private let resolver: ServiceResolver
    
    private let screen: SetupPayerDetailsScreen
    private var payWithCardScreen: PayWithCardScreen?
    
    private let screenManager: ScreenManager
    
    private let deviceAccessoryInteractor = DefaultDeviceAccessoryInteractor()
    private let mapper: APIToDomainModelsMapper = DefaultAPIToDomainModelsMapper()
    private let transactionBuilder: Domain.Transaction.Builder
    
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    init(for transaction: Transaction, with presenter: ViewControllerPresenter, using resolver: ServiceResolver) {
        self.transaction = transaction
        self.presenter = presenter
        self.resolver = resolver
        screen = SetupPayerDetailsScreen(for: transaction, using: resolver)
        screenManager = ScreenManager(presenter: presenter)
        transactionBuilder = Domain.Transaction.Builder(paymentInfo: mapper.makePaymentInfo(from: transaction))
    }
    
    deinit {
        Logger.debug("deinit from: \(self)")
    }
    
    // MARK: - API
    
    func start() {
        presentSetupPayerDetailsScreen()
    }
    
    func stop() { }
    
    // MARK: - Private
    
    private func presentSetupPayerDetailsScreen() {
        screen.router.onSetup
            .subscribe(onNext: { [weak self] payer in
                self?.transactionBuilder.set(payer: payer)
                self?.showChoosePaymentMethodScreen()
                self?.showPayerDetails.on(.next(payer))
            })
            .add(to: disposer)
        
        screenManager.show(screen)
    }
    
    private func showChoosePaymentMethodScreen() {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        let screen = ChoosePaymentMethodScreen(for: transaction, using: resolver)
        
        screen.router.showCardFlow
            .subscribe(onNext: { [weak self, unowned screen] in self?.showCardFlow(using: screen) })
            .add(to: disposer)
        
        screen.router.showBLIKFlow
            .subscribe(onNext: { [weak self, unowned screen] in self?.showBlikFlow(using: screen) })
            .add(to: disposer)
        
        screen.router.showRatyPekaoFlow
            .subscribe(onNext: { [weak self, unowned screen] in self?.showRatyPekaoFlow(using: screen) })
            .add(to: disposer)
        
        screen.router.showPBLFlow
            .subscribe(onNext: { [weak self, unowned screen] in self?.showPBLFlow(using: screen) })
            .add(to: disposer)
        
        screen.router.showDigitalWalletsFlow
            .subscribe(onNext: { [weak self, unowned screen] in self?.showDigitalWalletsFlow(using: screen) })
            .add(to: disposer)
        
        screen.router.showPayPoFlow
            .subscribe(onNext: { [weak self, unowned screen] in self?.showPayPoFlow(using: screen) })
            .add(to: disposer)
        
        screenManager.show(screen)
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
    
    @available(iOS 13.0, *)
    private func presentCardScanningScreen() {
        let cardScreen = CardScanningScreen()
        
        cardScreen.router.completeAction
            .subscribe(onNext: { [weak self, unowned cardScreen] data in
                self?.payWithCardScreen?.set(cardData: data)
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
    
    private func showCardFlow(using screen: ChoosePaymentMethodScreen) {
        if transaction.payerContext?.hasTokenizedCards ?? false {
            showOneClickFlow(using: screen)
        } else {
            showOneTimeFlow(using: screen)
        }
    }
    
    private func showBlikFlow(using screen: ChoosePaymentMethodScreen) {
        if transaction.payerContext?.hasRegisteredBlikAlias ?? false {
            showBlikOneClickFlow(using: screen)
        } else {
            showBlikCodeFlow(using: screen, isNavigationToOneClickEnabled: false)
        }
    }
    
    private func showBlikOneClickFlow(using screen: ChoosePaymentMethodScreen) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        guard let blikAlias = self.transaction.payerContext?.registeredBlikAlias else {
            assertionFailure("Cannot find blik alias object")
            return
        }
        
        let subScene = PayWithBlikAliasScreen(for: transaction, with: mapper.makeBlikAlias(from: blikAlias), using: resolver)
        
        subScene.router.onTransactionCreated
            .subscribe(queue: .main, onNext: { [weak self, unowned screen] transaction in self?.handleOnBlikAliasTransactionCreated(transaction, using: screen) })
            .add(to: disposer)
        
        subScene.router.onNavigateToBlikCode
            .subscribe(onNext: { [weak self, unowned screen] in self?.showBlikCodeFlow(using: screen, isNavigationToOneClickEnabled: true) })
            .add(to: disposer)
        
        subScene.router.onError
            .subscribe(onNext: { [weak self] error in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        screen.present(sub: subScene)
    }
    
    private func handleOnBlikAliasTransactionCreated(_ transaction: Domain.OngoingTransaction, using screen: ChoosePaymentMethodScreen) {
        guard case let .ambiguousBlikAlias(alternatives: alternatives) = transaction.paymentErrors?.first,
              let blikAlias = self.transaction.payerContext?.registeredBlikAlias else {
            transactionCreated.on(.next(transaction))
            return
        }
        let specificAliases = alternatives.map { alternative in
            var mappedAlias = mapper.makeBlikAlias(from: blikAlias)
            return mappedAlias.specified(using: .init(name: alternative.name, key: alternative.key))
        }
        showAmbiguousBlikAliasesFlow(for: transaction, with: specificAliases, using: screen)
    }
    
    private func showAmbiguousBlikAliasesFlow(for ongoingTransaction: Domain.OngoingTransaction,
                                              with aliases: [Domain.Blik.OneClick.Alias],
                                              using screen: ChoosePaymentMethodScreen) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        let subScene = PayWithAmbiguousBlikAliasesScreen(for: ongoingTransaction, with: aliases, transactionDetails: transaction, using: resolver)
        
        subScene.router.onTransactionCreated
            .subscribe(onNext: { [weak self] transaction in self?.transactionCreated.on(.next(transaction)) })
            .add(to: disposer)
        
        subScene.router.onNavigateToBlikCode
            .subscribe(onNext: { [weak self, unowned screen] in self?.showBlikCodeFlow(using: screen, isNavigationToOneClickEnabled: true) })
            .add(to: disposer)
        
        subScene.router.onError
            .subscribe(onNext: { [weak self] error in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        screen.present(sub: subScene)
    }
    
    private func showBlikCodeFlow(using screen: ChoosePaymentMethodScreen, isNavigationToOneClickEnabled: Bool) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        let subScene = PayWithBlikCodeScreen(for: transaction, using: resolver, isNavigationToOneClickEnabled: isNavigationToOneClickEnabled)
        
        subScene.router.onTransactionCreated
            .subscribe(onNext: { [weak self] transaction in self?.transactionCreated.on(.next(transaction)) })
            .add(to: disposer)
        
        subScene.router.onNavigateToOneClick
            .subscribe(onNext: { [weak self, unowned screen] in self?.showBlikOneClickFlow(using: screen) })
            .add(to: disposer)
        
        subScene.router.onError
            .subscribe(onNext: { [weak self] error in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        screen.present(sub: subScene)
    }
    
    private func showOneClickFlow(using screen: ChoosePaymentMethodScreen) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        let cardTokens = self.transaction.payerContext?.tokenizedCards.map { mapper.makeCardToken(from: $0) } ?? []
        let subScene = PayWithCardTokenScreen(for: transaction, with: cardTokens, using: resolver)
        
        subScene.router.onTransactionCreated
            .subscribe(onNext: { [weak self] transaction in self?.transactionCreated.on(.next(transaction)) })
            .add(to: disposer)
        
        subScene.router.onError
            .subscribe(onNext: { [weak self] error in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        subScene.router.onAddCardRequested
            .subscribe(onNext: { [weak self, unowned screen] in
                self?.showOneTimeFlow(using: screen)
            })
            .add(to: disposer)
        
        screen.present(sub: subScene)
    }
    
    private func showOneTimeFlow(using screen: ChoosePaymentMethodScreen) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        let isNavigationToOneClickEnabled = self.transaction.payerContext?.hasTokenizedCards ?? false
        let subScene = PayWithCardScreen(for: transaction, using: resolver, isNavigationToOneClickEnabled: isNavigationToOneClickEnabled)
        self.payWithCardScreen = subScene
        
        subScene.router.onTransactionCreated
            .subscribe(onNext: { [weak self] transaction in self?.transactionCreated.on(.next(transaction)) })
            .add(to: disposer)
        
        subScene.router.onCardScan
            .subscribe(onNext: { [weak self] in self?.handleStartCardScanning() })
            .add(to: disposer)
        
        subScene.router.onError
            .subscribe(onNext: { [weak self] error in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        subScene.router.onNavigateToOneClick
            .subscribe(onNext: { [weak self, unowned screen] in
                self?.payWithCardScreen = nil
                self?.showOneClickFlow(using: screen)
            })
            .add(to: disposer)
        
        screen.present(sub: subScene)
    }
    
    private func showRatyPekaoFlow(using screen: ChoosePaymentMethodScreen) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        let subScene = PayWithRatyPekaoScreen(for: transaction, using: resolver)
        
        subScene.router.onTransactionCreated
            .subscribe(onNext: { [weak self] transaction in self?.transactionCreated.on(.next(transaction)) })
            .add(to: disposer)

        subScene.router.onError
            .subscribe(onNext: { [weak self] error in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        screen.present(sub: subScene)
    }
    
    private func showPBLFlow(using screen: ChoosePaymentMethodScreen) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        let subScene = PayByLinkScreen(for: transaction, using: resolver)
        
        subScene.router.onTransactionCreated
            .subscribe(onNext: { [weak self] transaction in self?.transactionCreated.on(.next(transaction)) })
            .add(to: disposer)
        
        subScene.router.onError
            .subscribe(onNext: { [weak self] error in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        screen.present(sub: subScene)
    }
    
    private func showDigitalWalletsFlow(using screen: ChoosePaymentMethodScreen) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        let subScene = PayWithDigitalWalletScreen(for: transaction, using: resolver)
        
        subScene.router.onTransactionCreated
            .subscribe(onNext: { [weak self] transaction in self?.transactionCreated.on(.next(transaction)) })
            .add(to: disposer)
        
        subScene.router.onApplePay
            .subscribe(onNext: { [weak self] _ in self?.presentApplePayScreen(using: subScene) })
            .add(to: disposer)
        
        subScene.router.onError
            .subscribe(onNext: { [weak self] error in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        screen.present(sub: subScene)
    }
    
    private func showPayPoFlow(using screen: ChoosePaymentMethodScreen) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        let subScene = PayWithPayPoScreen(for: transaction, using: resolver)
        
        subScene.router.onTransactionCreated
            .subscribe(onNext: { [weak self] transaction in self?.transactionCreated.on(.next(transaction)) })
            .add(to: disposer)
        
        subScene.router.onError
            .subscribe(onNext: { [weak self] error in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        screen.present(sub: subScene)
    }
    
    private func presentApplePayScreen(using screen: PayWithDigitalWalletScreen) {
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        guard let applePayDelegate = (screen.viewController as? PayWithDigitalWalletViewController)?.applePayDelegate,
              let applePayScreen = ApplePayScreen(transaction: transaction, using: resolver) else { return }
        
        applePayScreen.set(delegate: applePayDelegate)
        
        screenManager.presentModally(applePayScreen)
    }
    
    private func presentNoCameraAccessDialog() {
        screenManager.presentNoCameraAccessDialog()
    }
}
