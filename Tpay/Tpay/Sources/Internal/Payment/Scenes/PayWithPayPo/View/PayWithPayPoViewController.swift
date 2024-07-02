//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

final class PayWithPayPoViewController: UIViewController {
    
    // MARK: - Properites
        
    private let contentView = ContentView()
    
    private let viewModel: PayWithPayPoViewModel
    
    // MARK: - Initialization

    init(with viewModel: PayWithPayPoViewModel) {
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

    }
        
    private func bindViewModelWithView() {
        contentView.set(initialPayerName: viewModel.payerName)
        contentView.set(initialPayerEmail: viewModel.payerEmail)
        contentView.set(initialPayerStreetAddress: viewModel.payerStreetAdress)
        contentView.set(initialPayerPostalCodeAddress: viewModel.payerPostalCodeAdress)
        contentView.set(initialPayerCityAddress: viewModel.payerCityAdress)
        
        viewModel.payerNameState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(payerNameState: state) })
            .add(to: disposer)
        
        viewModel.payerEmailState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(payerEmailState: state) })
            .add(to: disposer)
        
        viewModel.payerStreetAdressState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(payerStreetAddressState: state) })
            .add(to: disposer)
        
        viewModel.payerPostalCodeAdressState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(payerPostalCodeAddressState: state) })
            .add(to: disposer)
        
        viewModel.payerCityAdressState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(payerCityAddressState: state) })
            .add(to: disposer)
        
        viewModel.isProcessing
            .subscribe(queue: .main, onNext: { [weak self] isProcessing in self?.contentView.set(isProcessing: isProcessing) })
            .add(to: disposer)
    }
    
    private func bindViewWithViewModel() {
        contentView.payerNameEmitted
            .subscribe(onNext: { [weak self] name in self?.viewModel.set(payerName: name) })
            .add(to: disposer)
        
        contentView.payerEmailEmitted
            .subscribe(onNext: { [weak self] email in self?.viewModel.set(payerEmail: email) })
            .add(to: disposer)
        
        contentView.payerStreetAddressEmitted
            .subscribe(onNext: { [weak self] streetAddress in self?.viewModel.set(payerStreetAdress: streetAddress) })
            .add(to: disposer)
        
        contentView.payerPostalCodeAddressEmitted
            .subscribe(onNext: { [weak self] postalCode in self?.viewModel.set(payerPostalCodeAdress: postalCode) })
            .add(to: disposer)
        
        contentView.payerCityAddressEmitted
            .subscribe(onNext: { [weak self] cityAddress in self?.viewModel.set(payerCityAdress: cityAddress) })
            .add(to: disposer)
        
        contentView.payButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.contentView.endEditing(true)
                self?.viewModel.invokePayment()
            })
            .add(to: disposer)
    }
}
