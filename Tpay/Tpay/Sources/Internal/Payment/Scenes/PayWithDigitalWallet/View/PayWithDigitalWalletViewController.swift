//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

final class PayWithDigitalWalletViewController: UIViewController {
    
    // MARK: - Properties
    
    private(set) lazy var applePayDelegate = ApplePayDelegate(viewModel: viewModel)
    
    private let viewModel: PayWithDigitalWalletViewModel
    private let contentView = ContentView()
    
    private let collectionViewDelegate = ContentView.CollectionView.Delegate()
    private lazy var collectionViewDataSource = ContentView.CollectionView.DataSource(viewModel: viewModel)
    
    // MARK: - Initialization

    init(with viewModel: PayWithDigitalWalletViewModel) {
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
        bindViewModelWithView()
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.collectionView.delegate = collectionViewDelegate
        contentView.collectionView.dataSource = collectionViewDataSource
        
        contentView.set(transaction: viewModel.transaction)
    }
    
    private func bindViewWithViewModel() {
        collectionViewDelegate.indexPathSelected
            .subscribe(onNext: { [weak self] indexPath in self?.selectDigitalWallet(at: indexPath) })
            .add(to: disposer)
        
        contentView.payButtonTapped
            .subscribe(queue: .main, onNext: { [weak self] _ in self?.viewModel.invokePayment() })
            .add(to: disposer)
    }
    
    private func bindViewModelWithView() {
        viewModel.isProcessing
            .subscribe(queue: .main, onNext: { [weak self] isProcessing in self?.contentView.set(isProcessing: isProcessing) })
            .add(to: disposer)
        
        viewModel.isValid
            .subscribe(queue: .main, onNext: { [weak self] isValid in self?.contentView.set(isValid: isValid) })
            .add(to: disposer)
    }
    
    private func selectDigitalWallet(at indexPath: IndexPath) {
        let digitalWallet = viewModel.digitalWallets[indexPath.row]
        viewModel.select(digitalWallet: digitalWallet)
    }
}
