//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
final class CardScanningViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: CardScanningViewModel
    
    private let contentView = ContentView()
    
    override var shouldAutorotate: Bool {
        false
    }
    
    // MARK: - Initialization

    init(viewModel: CardScanningViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    deinit {
        Logger.debug("deinit from \(self)")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModelWithView()
        bindViewWithViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.contentView.startSession()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        contentView.stopSession()
    }
    
    // MARK: - Private
    
    private func bindViewModelWithView() {
        
    }
    
    private func bindViewWithViewModel() {
        contentView.closeButtonTapped
            .subscribe(onNext: { [weak self] in self?.viewModel.close() })
            .add(to: disposer)
        
        contentView.cardData
            .subscribe(onNext: { [weak self] cardData in self?.viewModel.creditCardScanned(data: cardData) })
            .add(to: disposer)
    }
}
