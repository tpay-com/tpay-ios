//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class AddCardCoordinator {
 
    // MARK: - Events
    
    var closeModule: Observable<Void> { sheetViewController.closeButtonTapped }
    let tokenizationCompleted = Observable<Void>()
    let tokenizationFailed = Observable<Void>()
    
    // MARK: - Properties
    
    let sheetViewController: SheetViewController
    
    private let presenter: ViewControllerPresenter
    private let resolver = ModuleContainer.instance.resolver
    
    private let payer: Payer?
    
    private var disposer = Disposer()
    private var currentFlow: ModuleFlow? {
        didSet {
            oldValue?.stop()
            currentFlow?.start()
        }
    }
    
    // MARK: - Initializer
    
    init(payer: Payer?) {
        self.payer = payer
        sheetViewController = SheetViewController()
        presenter = ContentViewControllerPresenter(sheetViewController: sheetViewController)
    }
    
    deinit {
        Logger.debug("deinit from: \(self)")
    }
    
    // MARK: - API
    
    func start() {
        setupActions()
        startAddCardFlow()
    }
    
    func stop() {
        currentFlow = nil
    }
    
    // MARK: - Private
    
    private func setupActions() {
        sheetViewController.languageSelected
            .skip(first: 1)
            .subscribe(onNext: { [weak self] language in self?.changeLanguage(language) })
            .add(to: disposer)
    }
    
    private func startAddCardFlow() {
        let addCardFlow = AddCardFlow(with: presenter, using: resolver, payer: payer)
        
        addCardFlow.tokenizationCancelled
            .forward(to: tokenizationFailed)
        
        addCardFlow.tokenizationCompleted
            .forward(to: tokenizationCompleted)
        
        addCardFlow.titleImage
            .subscribe(queue: .main, onNext: { [weak self] image in self?.sheetViewController.set(titleImage: image) })
            .add(to: disposer)
        
        currentFlow = addCardFlow
    }
    
    private func changeLanguage(_ to: Language) {
        ModuleContainer.instance.currentLanguage = to
        startAddCardFlow()
    }
}
