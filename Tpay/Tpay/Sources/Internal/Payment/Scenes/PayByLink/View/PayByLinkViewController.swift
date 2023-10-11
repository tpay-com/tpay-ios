//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayByLinkViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: PayByLinkViewModel
    private let contentView = ContentView()
    
    private let collectionViewDelegate = ContentView.CollectionView.Delegate()
    private lazy var collectionViewDataSource = ContentView.CollectionView.DataSource(viewModel: viewModel)
    
    // MARK: - Initialization

    init(with viewModel: PayByLinkViewModel) {
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
        contentView.payButtonTapped
            .subscribe(onNext: { [weak self] in self?.viewModel.invokePayment() })
            .add(to: disposer)
        
        collectionViewDelegate.indexPathSelected
            .subscribe(onNext: { [weak self] indexPath in self?.selectBank(at: indexPath) })
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
    
    private func selectBank(at indexPath: IndexPath) {
        let bank = viewModel.banks[indexPath.row]
        viewModel.select(bank: bank)
    }
}
