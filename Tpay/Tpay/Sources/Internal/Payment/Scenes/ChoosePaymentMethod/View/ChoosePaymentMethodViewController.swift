//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ChoosePaymentMethodViewController: UIViewController {

    // MARK: - Properites
    
    let viewModel: ChoosePaymentMethodViewModel
    
    private let collectionViewDelegate = ContentView.CollectionView.Delegate()
    private lazy var collectionViewDataSource = ContentView.CollectionView.DataSource(viewModel: viewModel)
    
    private let contentView = ContentView()
    private var currentController: UIViewController?
    
    private let keyboardObserver = DefaultKeyboardObserver()
    
    // MARK: - Initialization

    init(with viewModel: ChoosePaymentMethodViewModel) {
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
        keyboardObserver.notifyKeyboardChanges(on: contentView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bindViewWithViewModel()
        selectInitialPaymentMethod()
    }
    
    // MARK: - API
    
    func set(payment viewController: UIViewController) {
        guard let disappearing = currentController else {
            transitionTo(first: viewController)
            return
        }
        transition(from: disappearing, to: viewController)
    }
    
    // MARK: - Private
    
    private func setupComponents() {
        contentView.collectionView.delegate = collectionViewDelegate
        contentView.collectionView.dataSource = collectionViewDataSource
    }
    
    private func selectInitialPaymentMethod() {
        let index = viewModel.getPaymentMethods().firstIndex(of: viewModel.initialPaymentMethod) ?? 0
        let indexPath = IndexPath(row: index, section: 0)
        contentView.select(paymentMethod: indexPath)
        collectionViewDelegate.collectionView(contentView.collectionView, didSelectItemAt: indexPath)
    }
    
    private func bindViewWithViewModel() {
        collectionViewDelegate.indexPathSelected
            .subscribe(onNext: { [weak self] indexPath in self?.chooseMethod(at: indexPath) })
            .add(to: disposer)
    }
    
    private func chooseMethod(at indexPath: IndexPath) {
        let paymentMethods = viewModel.getPaymentMethods()
        let selectedMethod = paymentMethods[indexPath.row]
        viewModel.choose(method: selectedMethod)
    }
    
    private func transitionTo(first viewController: UIViewController) {
        addChild(viewController)
        contentView.set(payment: viewController.view)
        viewController.didMove(toParent: self)
        currentController = viewController
    }
    
    private func transition(from disappearing: UIViewController, to appearing: UIViewController) {
        appearing.willMove(toParent: self)
        disappearing.willMove(toParent: nil)
        
        appearing.view.alpha = 0
        
        contentView.isUserInteractionEnabled = false
        contentView.set(payment: appearing.view)
                
        UIView.animateKeyframes(withDuration: 0.6,
                                delay: 0,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33, animations: { disappearing.view.alpha = 0 })
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: { appearing.view.alpha = 1 })
        }, completion: { [weak self] _ in
            disappearing.view.removeFromSuperview()
            disappearing.removeFromParent()
            
            appearing.didMove(toParent: self)
            disappearing.didMove(toParent: nil)
            
            self?.contentView.isUserInteractionEnabled = true            
            self?.currentController = appearing
        })
    }
}

extension ChoosePaymentMethodViewController: SheetAppearanceAware {
    
    func adjust(for appearance: SheetViewController.ContentView.Appearance) {
        contentView.adjust(for: appearance)
    }
}

extension ChoosePaymentMethodViewController: SheetConfigurable {
    
    var sheetContext: SheetViewController.Context { .init(topSection: .payerDetails) }
}
