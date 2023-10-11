//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class SuccessViewController: UIViewController {
    
    // MARK: - Properites
    
    let viewModel: SuccessViewModel
    
    private let contentView = ContentView()
    private let feedbackGenerator: FeedbackGenerator = DefaultFeedbackGenerator()
    
    // MARK: - Initialization

    init(with viewModel: SuccessViewModel) {
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
        
        feedbackGenerator.generateFeedback(type: .success)
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.set(content: viewModel.content)
    }
    
    private func bindViewWithViewModel() {
        contentView.buttonTapped
            .subscribe(onNext: { [weak self] in self?.viewModel.proceed() })
            .add(to: disposer)
    }
}

extension SuccessViewController: SheetConfigurable {
    
    var sheetContext: SheetViewController.Context { .init(topSection: .none, appearance: .fixed(.compact), isCancellable: false) }
}
