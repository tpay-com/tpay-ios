//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class DefaultViewControllerPresenter: ViewControllerPresenter {
    
    // MARK: - Type aliases
    
    typealias BackClosure = () -> Void
    
    // MARK: - Properties
    
    private let navigationController: NavigationController
    private let transitioningDelegate: UIViewControllerTransitioningDelegate
    
    private var backClosures: [String: BackClosure] = [:]
    
    // MARK: - Getters
    
    var rootViewController: UIViewController { navigationController.baseNavigationController }
    
    // MARK: - Initializers
    
    convenience init(using navigationController: NavigationController) {
        self.init(navigationController: navigationController,
                  transitioningDelegate: TransitioningDelegate())
    }
    
    init(navigationController: NavigationController, transitioningDelegate: UIViewControllerTransitioningDelegate) {
        self.navigationController = navigationController
        self.transitioningDelegate = transitioningDelegate
        
        setupActions()
    }
    
    // MARK: - Private
    
    private func setupActions() {
        navigationController.didShow(on: self) { [weak navigationController] presenter, viewController  in
            guard
                let fromViewController = navigationController?.baseNavigationController.transitionCoordinator?.viewController(forKey: .from),
                !(navigationController?.baseNavigationController.viewControllers.contains(fromViewController) ?? true)
            else {
                return
            }
            guard let closure = presenter.backClosures.removeValue(forKey: fromViewController.description) else { return }
            closure()
        }
    }
    
    // MARK: - API
    
    func removeFromStack(_ viewController: UIViewController) {
        let controllers = navigationController.baseNavigationController.viewControllers
        navigationController.baseNavigationController.setViewControllers(controllers.filter { item in item !== viewController }, animated: false)
    }
    
    func didShow<Observer: AnyObject>(viewController: UIViewController, on observer: Observer, didShow: @escaping (Observer) -> Void) {
        navigationController.didShow(on: observer) { observer, presentedViewController in
            if viewController === presentedViewController { didShow(observer) }
        }
    }
    
    func show(_ viewController: UIViewController) {
        navigationController.show(viewController: viewController)
    }
    
    func show(_ viewController: UIViewController, then: @escaping () -> Void) {
        show(viewController)
        
        guard let coordinator = navigationController.baseNavigationController.transitionCoordinator else {
            then()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in then() }
    }
    
    func push(_ viewController: UIViewController) {
        navigationController.push(viewController: viewController)
    }
    
    func push(_ viewController: UIViewController, then: (() -> Void)? = nil, onBack: BackClosure? = nil) {
        push(viewController)
        
        guard let coordinator = navigationController.baseNavigationController.transitionCoordinator else {
            then?()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in then?() }
    }
    
    func dismiss() {
        navigationController.baseNavigationController.presentedViewController?.dismiss(animated: true)
    }
    
    func pop() {
        navigationController.pop()
    }
    
    func pop(to viewController: UIViewController) {
        navigationController.baseNavigationController.popToViewController(viewController, animated: true)
    }
    
    func presentPageSheet(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .pageSheet
        navigationController.present(viewController: viewController)
    }
    
    /// Presents view controller as full screen modal
    /// - Parameter viewController: presented view controller
    func presentFullScreen(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        navigationController.baseNavigationController.present(viewController, animated: true)
    }
    
    /// Presents view controller modally
    /// - Parameter viewController: presented view controller
    func presentModally(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = transitioningDelegate
        
        navigationController.baseNavigationController.present(viewController, animated: true)
    }
}
