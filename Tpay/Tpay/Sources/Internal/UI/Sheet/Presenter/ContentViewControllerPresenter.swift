//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ContentViewControllerPresenter: ViewControllerPresenter {
    
    // MARK: - Properties
    
    var rootViewController: UIViewController { sheetViewController }
    
    private let sheetViewController: SheetViewController
    private let sheetViewControllerTransitioningDelegate = SheetViewController.TransitioningDelegate()
    private let fullScreenTransitioningDelegate = FullScreenTransitioningDelegate()
    
    // MARK: - Initializers
    
    init(sheetViewController: SheetViewController) {
        self.sheetViewController = sheetViewController
        
        sheetViewController.modalPresentationStyle = .custom
        sheetViewController.transitioningDelegate = sheetViewControllerTransitioningDelegate
    }
    
    // MARK: - API
    
    func removeFromStack(_ viewController: UIViewController) {
    
    }
    
    func didShow<Observer>(viewController: UIViewController, on observer: Observer, didShow: @escaping (Observer) -> Void) where Observer: AnyObject {
        
    }
    
    func show(_ viewController: UIViewController) {
        let context = (viewController as? SheetConfigurable)?.sheetContext ?? .default
        sheetViewController.set(content: viewController, with: context)
    }
    
    func show(_ viewController: UIViewController, then: @escaping () -> Void) {
        
    }
    
    func push(_ viewController: UIViewController) {
        
    }
    
    func push(_ viewController: UIViewController, then: (() -> Void)?, onBack: (() -> Void)?) {
        
    }
    
    func dismiss() {
        
    }
    
    func pop() {
        
    }
    
    func pop(to viewController: UIViewController) {

    }
    
    func presentPageSheet(_ viewController: UIViewController) {
        
    }
    
    func presentFullScreen(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = fullScreenTransitioningDelegate
        
        sheetViewController.goFullScreen()
        rootViewController.present(viewController, animated: true)
    }
    
    func presentModally(_ viewController: UIViewController) {
        rootViewController.present(viewController, animated: true)
    }
}
