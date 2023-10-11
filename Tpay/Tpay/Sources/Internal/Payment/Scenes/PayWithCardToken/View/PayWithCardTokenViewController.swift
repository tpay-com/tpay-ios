//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayWithCardTokenViewController: UIViewController {
    
    // MARK: - Properites
    
    let viewModel: PayWithCardTokenViewModel
    
    private let contentView = ContentView()
    
    private let collectionViewDelegate = ContentView.CollectionView.Delegate()
    private lazy var collectionViewDataSource = ContentView.CollectionView.DataSource(viewModel: viewModel)
    
    // MARK: - Initialization

    init(with viewModel: PayWithCardTokenViewModel) {
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
        
        bindViewModelWithView()
        bindViewWithViewModel()
        
        selectInitialCardToken()
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.collectionView.delegate = collectionViewDelegate
        contentView.collectionView.dataSource = collectionViewDataSource
        
        contentView.set(transaction: viewModel.transaction)
    }
    
    private func bindViewModelWithView() {
        viewModel.isProcessing
            .subscribe(queue: .main, onNext: { [weak self] isProcessing in self?.contentView.set(isProcessing: isProcessing) })
            .add(to: disposer)
    }
    
    private func bindViewWithViewModel() {
        contentView.addCardButtonTapped
            .subscribe(onNext: { [weak self] in self?.viewModel.addCard() })
            .add(to: disposer)
        
        contentView.payButtonTapped
            .subscribe(onNext: { [weak self] in self?.viewModel.invokePayment() })
            .add(to: disposer)
        
        collectionViewDelegate.indexPathSelected
            .subscribe(onNext: { [weak self] indexPath in self?.selectCardToken(at: indexPath) })
            .add(to: disposer)
    }
    
    private func selectInitialCardToken() {
        guard let initiallySelectedCardToken = viewModel.initiallySelectedCardToken else { return }
        let index = viewModel.cardTokens.firstIndex(of: initiallySelectedCardToken) ?? 0
        let indexPath = IndexPath(row: index, section: 0)
        contentView.selectCardToken(at: indexPath)
    }
    
    private func selectCardToken(at indexPath: IndexPath) {
        let cardToken = viewModel.cardTokens[indexPath.row]
        viewModel.select(cardToken: cardToken)
    }
}
