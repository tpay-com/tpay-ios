//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class SetupPayerDetailsViewController: UIViewController {

    // MARK: - Properites
    
    private let contentView = ContentView()
    
    private let viewModel: SetupPayerDetailsViewModel
    
    // MARK: - Initialization

    init(with viewModel: SetupPayerDetailsViewModel) {
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
        
        bindViewModelWithView()
        bindViewWithViewModel()
    }
    
    // MARK: - Private
    
    private func bindViewModelWithView() {
        contentView.set(initialPayerName: viewModel.initialPayerName)
        contentView.set(initialPayerEmail: viewModel.initialPayerEmail)
        
        viewModel.payerNameState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(payerNameState: state) })
            .add(to: disposer)
        
        viewModel.payerEmailState
            .subscribe(onNext: { [weak self] state in self?.contentView.set(payerEmailState: state) })
            .add(to: disposer)
        
        viewModel.isProcessing
            .subscribe(onNext: { [weak self] isProcessing in self?.contentView.set(isProcessing: isProcessing) })
            .add(to: disposer)
    }
    
    private func bindViewWithViewModel() {
        contentView.payerNameEmitted
            .subscribe(onNext: { [weak self] name in self?.viewModel.set(payerName: name) })
            .add(to: disposer)
        
        contentView.payerEmailEmitted
            .subscribe(onNext: { [weak self] email in self?.viewModel.set(payerEmail: email) })
            .add(to: disposer)
        
        contentView.choosePaymentMethodTapped
            .subscribe(onNext: { [weak self] in
                self?.contentView.endEditing(true)
                self?.viewModel.choosePaymentMethod()
            })
            .add(to: disposer)
    }
}

extension SetupPayerDetailsViewController: SheetAppearanceAware {
    
    func adjust(for appearance: SheetViewController.ContentView.Appearance) {
        contentView.adjust(for: appearance)
    }
}

extension SetupPayerDetailsViewController: SheetConfigurable {
    
    var sheetContext: SheetViewController.Context { .init(topSection: Language.supported.count > 1 ? .languageSwitcher : .none) }
}
