//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class FailureViewController: UIViewController {
    
    // MARK: - Properites
    
    let viewModel: FailureViewModel
    
    private let contentView = ContentView()
    private let feedbackGenerator: FeedbackGenerator = DefaultFeedbackGenerator()
    
    // MARK: - Initialization

    init(with viewModel: FailureViewModel) {
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
        
        feedbackGenerator.generateFeedback(type: .failure)
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.set(content: viewModel.content)
    }
    
    private func bindViewWithViewModel() {
        contentView.primaryButtonTapped
            .subscribe(onNext: { [weak self] in self?.viewModel.primaryAction() })
            .add(to: disposer)
        
        contentView.cancelButtonTapped
            .subscribe(onNext: { [weak self] in self?.viewModel.cancel() })
            .add(to: disposer)
    }
}

extension FailureViewController: SheetConfigurable {
    
    var sheetContext: SheetViewController.Context { .init(topSection: .none, appearance: .fixed(.compact), isCancellable: false) }
}
