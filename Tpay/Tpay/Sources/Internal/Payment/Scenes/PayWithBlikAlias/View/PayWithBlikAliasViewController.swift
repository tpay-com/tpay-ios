//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Combine
import UIKit

final class PayWithBlikAliasViewController: UIViewController {
    
    // MARK: - Properites
    
    private let contentView = ContentView()
    private let viewModel: PayWithBlikAliasViewModel

    // MARK: - Initializers

    init(viewModel: PayWithBlikAliasViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - LifeCycle

    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()
        
        bindViewWithViewModel()
        bindViewModelWithView()
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.set(transaction: viewModel.transaction)
    }
    
    private func bindViewWithViewModel() {
        contentView.payButtonTapped
            .subscribe(onNext: { [weak self] in self?.viewModel.invokePayment() })
            .add(to: disposer)
        
        contentView.payByCodeTapped
            .subscribe(onNext: { [weak self] in self?.viewModel.navigateToBlikCode() })
            .add(to: disposer)
    }
    
    private func bindViewModelWithView() {
        viewModel.isProcessing
            .subscribe(queue: .main, onNext: { [weak self] isProcessing in self?.contentView.set(isProcessing: isProcessing) })
            .add(to: disposer)
    }
}
