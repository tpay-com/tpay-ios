//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayWithBlikCodeViewController: UIViewController {
    
    // MARK: - Properites
    
    private let viewModel: PayWithBlikCodeViewModel
    private lazy var contentView = ContentView(isNavigationToAliasesEnabled: viewModel.isNavigationToOneClickEnabled)
    
    // MARK: - Initialization

    init(with viewModel: PayWithBlikCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endEditingOnTap()
        setupComponents()
        
        bindViewWithViewModel()
        bindViewModelWithView()
    }
    
    // MARK: - API
    
    private func setupComponents() {
        contentView.set(transaction: viewModel.transaction)
        contentView.set(isAliasRegistrationSectionHidden: !viewModel.shouldAllowAliasRegistration)
    }
    
    private func bindViewWithViewModel() {
        contentView.navigateToAliasesButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.contentView.endEditing(true)
                self?.viewModel.navigateBackToOneClick()
            })
            .add(to: disposer)
        
        contentView.blikCodeEmitted
            .subscribe(onNext: { [weak self] in self?.viewModel.set(blikCode: $0) })
            .add(to: disposer)
        
        contentView.registerAliasSelectionChanged
            .subscribe(onNext: { [weak self] shouldRegisterAlias in
                self?.viewModel.set(shouldRegisterAlias: shouldRegisterAlias)
                self?.contentView.set(isAliasLabelInputHidden: !shouldRegisterAlias)
                self?.contentView.layoutIfNeeded()
            })
            .add(to: disposer)
        
        contentView.aliasLabelEmitted
            .subscribe(onNext: { [weak self] in self?.viewModel.set(aliasLabel: $0) })
            .add(to: disposer)
        
        contentView.payButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.contentView.endEditing(true)
                self?.viewModel.invokePayment()
            })
            .add(to: disposer)
    }
    
    private func bindViewModelWithView() {
        viewModel.blikCodeState
            .subscribe(onNext: { [weak self] in self?.contentView.set(blikCodeState: $0) })
            .add(to: disposer)
        
        viewModel.isProcessing
            .subscribe(queue: .main, onNext: { [weak self] in self?.contentView.set(isProcessing: $0) })
            .add(to: disposer)
    }
}
