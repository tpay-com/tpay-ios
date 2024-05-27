//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

final class ProcessExternallyGeneratedTransactionViewController: UIViewController {
    
    // MARK: - Properites
    
    let viewModel: ProcessExternallyGeneratedTransactionViewModel
    
    private lazy var contentView = ContentView(successUrl: viewModel.successUrl, errorUrl: viewModel.errorUrl)
    
    // MARK: - Initialization

    init(with viewModel: ProcessExternallyGeneratedTransactionViewModel) {
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
        
        setupComponents()
        
        bindViewWithViewModel()
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.load(transactionPaymentUrl: viewModel.transactionPaymentUrl)
    }
    
    private func bindViewWithViewModel() {
        contentView.completedWithSuccess
            .subscribe(onNext: { [weak self] in self?.viewModel.completeWithSuccess() })
            .add(to: disposer)
        
        contentView.completedWithError
            .subscribe(onNext: { [weak self] in self?.viewModel.completeWithError() })
            .add(to: disposer)
    }
}

extension ProcessExternallyGeneratedTransactionViewController: SheetConfigurable {
    
    var sheetContext: SheetViewController.Context { .init(topSection: .none, appearance: .fixed(.large)) }
}
