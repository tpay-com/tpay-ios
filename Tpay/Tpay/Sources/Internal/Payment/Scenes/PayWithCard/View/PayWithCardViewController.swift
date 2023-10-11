//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayWithCardViewController: UIViewController {
    
    // MARK: - Properites
    
    let viewModel: PayWithCardViewModel
    
    private lazy var contentView = ContentView(isNavigationToOneClickEnabled: viewModel.isNavigationToOneClickEnabled)
    
    // MARK: - Initialization

    init(with viewModel: PayWithCardViewModel) {
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
        
        bindViewModelWithView()
        bindViewWithViewModel()
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.set(transaction: viewModel.transaction)
        contentView.set(merchantDetails: viewModel.merchantDetails)
    }
        
    private func bindViewModelWithView() {
        viewModel.cardNumberState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(cardNumberState: state) })
            .add(to: disposer)
        
        viewModel.cardExpiryDateState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(cardExpiryDateState: state) })
            .add(to: disposer)
        
        viewModel.cardSecurityCodeState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(cardSecurityCodeState: state) })
            .add(to: disposer)
        
        viewModel.cardBrand
            .subscribe(onNext: { [weak self] brand in self?.contentView.set(cardBrand: brand) })
            .add(to: disposer)
        
        viewModel.cardData
            .subscribe(onNext: { [weak self] data in self?.contentView.set(cardData: data) })
            .add(to: disposer)
        
        viewModel.isProcessing
            .subscribe(queue: .main, onNext: { [weak self] isProcessing in self?.contentView.set(isProcessing: isProcessing) })
            .add(to: disposer)
    }
    
    private func bindViewWithViewModel() {
        contentView.cardNumberEmitted
            .subscribe(onNext: { [weak self] cardNumber in self?.viewModel.set(cardNumber: cardNumber) })
            .add(to: disposer)
        
        contentView.cardExpiryDateEmitted
            .subscribe(onNext: { [weak self] cardExpiryDate in self?.viewModel.set(cardExpiryDate: cardExpiryDate) })
            .add(to: disposer)
        
        contentView.cardSecurityCodeEmitted
            .subscribe(onNext: { [weak self] cardSecurityCode in self?.viewModel.set(cardSecurityCode: cardSecurityCode) })
            .add(to: disposer)
        
        contentView.cardSecurityCodeReset
            .subscribe(onNext: { [weak self] _ in self?.viewModel.resetCardSecurityCode() })
            .add(to: disposer)
        
        contentView.saveCardSelectionChanged
            .subscribe(onNext: { [weak self] shouldSaveCard in self?.viewModel.set(shouldSaveCard: shouldSaveCard) })
            .add(to: disposer)
        
        contentView.payButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.contentView.endEditing(true)
                self?.viewModel.invokePayment()
            })
            .add(to: disposer)
        
        contentView.ocrButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.contentView.endEditing(true)
                self?.viewModel.invokeCardScan()
            })
            .add(to: disposer)
        
        contentView.navigateToOneClickButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.contentView.endEditing(true)
                self?.viewModel.navigateBackToOneClick()
            })
            .add(to: disposer)
    }
}
