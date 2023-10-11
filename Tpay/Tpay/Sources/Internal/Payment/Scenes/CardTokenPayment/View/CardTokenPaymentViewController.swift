//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

final class CardTokenPaymentViewController: UIViewController {
    
    // MARK: - Properites
    
    private let contentView = ContentView()
    
    private let viewModel: CardTokenPaymentViewModel
    
    // MARK: - Initialization

    init(with viewModel: CardTokenPaymentViewModel) {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.invokePayment()
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.set(title: viewModel.title)
        contentView.set(message: viewModel.message)
    }
}

extension CardTokenPaymentViewController: SheetConfigurable {
    
    var sheetContext: SheetViewController.Context { .init(topSection: .none, appearance: .fixed(.compact), isCancellable: false) }
}
