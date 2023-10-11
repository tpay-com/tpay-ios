//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class SnackbarViewController: UIViewController {
    
    // MARK: - Properties
    
    private let contentView: ContentView
    private let feedbackGenerator: FeedbackGenerator = DefaultFeedbackGenerator()
    
    // MARK: - Initializers
    
    init(snack: Snack) {
        self.contentView = ContentView(snack: snack)
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
        
        feedbackGenerator.generateFeedback(type: .failure)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupActions()
        contentView.startCountdown()
    }
    
    // MARK: - Private
    
    private func setupActions() {
        contentView.countdownFinished
            .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
            .add(to: disposer)
        
        contentView.tap
            .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
            .add(to: disposer)
    }
}
