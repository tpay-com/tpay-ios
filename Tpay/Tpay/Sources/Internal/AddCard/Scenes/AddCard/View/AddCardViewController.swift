//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

final class AddCardViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: AddCardViewModel
    
    private let contentView = ContentView()
    
    // MARK: - Initialization
    
    init(viewModel: AddCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    deinit {
        Logger.debug("deinit from \(self)")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.addCardHeadline
        
        endEditingOnTap()
        
        setupComponents()
        
        bindViewModelWithView()
        bindViewWithViewModel()
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.set(merchantDetails: viewModel.merchantDetails)
    }
    
    private func bindViewModelWithView() {
        contentView.set(initialPayerName: viewModel.initialPayerName)
        contentView.set(initialPayerEmail: viewModel.initialPayerEmail)
        
        viewModel.payerNameState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(payerNameState: state) })
            .add(to: disposer)
        
        viewModel.payerEmailState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(payerEmailState: state) })
            .add(to: disposer)
        
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
        contentView.payerNameEmitted
            .subscribe(onNext: { [weak self] payerName in self?.viewModel.set(payerName: payerName) })
            .add(to: disposer)
        
        contentView.payerEmailEmitted
            .subscribe(onNext: { [weak self] payerEmail in self?.viewModel.set(payerEmail: payerEmail) })
            .add(to: disposer)
        
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

        contentView.ocrButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.contentView.endEditing(true)
                self?.viewModel.invokeCardScan()
            })
            .add(to: disposer)
        
        contentView.saveButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.contentView.endEditing(true)
                self?.viewModel.saveCard()
            })
            .add(to: disposer)
    }
}
