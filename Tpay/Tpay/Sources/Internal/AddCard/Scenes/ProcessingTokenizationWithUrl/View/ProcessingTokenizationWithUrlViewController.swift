//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ProcessingTokenizationWithUrlViewController: UIViewController {
    
    // MARK: - Properites
    
    let viewModel: ProcessingTokenizationWithUrlViewModel
    
    private lazy var contentView = ContentView(successUrl: viewModel.successUrl, errorUrl: viewModel.errorUrl)
    
    // MARK: - Initialization

    init(with viewModel: ProcessingTokenizationWithUrlViewModel) {
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
        contentView.load(continueUrl: viewModel.continueUrl)
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

extension ProcessingTokenizationWithUrlViewController: SheetConfigurable {
    
    var sheetContext: SheetViewController.Context { .init(topSection: .none, appearance: .fixed(.large), isCancellable: false) }
}
