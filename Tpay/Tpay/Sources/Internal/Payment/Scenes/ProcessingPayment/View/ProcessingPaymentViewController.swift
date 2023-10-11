//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ProcessingPaymentViewController: UIViewController {

    // MARK: - Properites
    
    private let contentView = ContentView()
    
    private let viewModel: ProcessingPaymentViewModel
    
    // MARK: - Initialization

    init(with viewModel: ProcessingPaymentViewModel) {
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
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.set(title: viewModel.title)
        contentView.set(message: viewModel.message)
    }
}

extension ProcessingPaymentViewController: SheetConfigurable {
    
    var sheetContext: SheetViewController.Context { .init(topSection: .none, appearance: .fixed(.compact), isCancellable: false) }
}
