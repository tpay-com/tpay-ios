//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class DefaultNavigationController: NavigationController {
    
    // MARK: - Properties

    let baseNavigationController: UINavigationController
    
    private let delegate = NavigationControllerDelegate()
    private let backButtonItemProducer: () -> UIBarButtonItem?
    
    // MARK: - Getters
    
    var baseViewController: UIViewController { baseNavigationController }
    
    // MARK: - Initializers
    
    convenience init(with backButtonItem: @escaping () -> UIBarButtonItem) {
        self.init(baseNavigationController: UINavigationController(), with: backButtonItem)
    }
    
    init(baseNavigationController: UINavigationController, with backButtonItem: @escaping () -> UIBarButtonItem) {
        backButtonItemProducer = backButtonItem
        baseNavigationController.delegate = delegate
        self.baseNavigationController = baseNavigationController
    }
    
    deinit {
        print("DefaultNavigationController deinited")
    }
    
    // MARK: - API
    
    func didShow<Observer: AnyObject>(on observer: Observer, didShow: @escaping (Observer, UIViewController) -> Void) {
        delegate.didShow(on: observer, didShow: didShow)
    }
    
    func showNavigationBar() {
        baseNavigationController.setNavigationBarHidden(false, animated: false)
    }
    
    func hideNavigationBar() {
        baseNavigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func prefersLargeTitles() {
        baseNavigationController.navigationBar.prefersLargeTitles = true
    }
    
    func setLargeTitleIndent(_ indent: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = indent
        style.headIndent = indent
        if var attributes = baseNavigationController.navigationBar.largeTitleTextAttributes {
            attributes[.paragraphStyle] = style
        } else {
            var attributes = [NSAttributedString.Key: Any]()
            attributes[.paragraphStyle] = style
            baseNavigationController.navigationBar.largeTitleTextAttributes = attributes
        }
    }
    
    func show(viewController: UIViewController) {
        viewController.navigationItem.backBarButtonItem = backButtonItemProducer()
        
        let animated = !baseNavigationController.viewControllers.isEmpty
        baseNavigationController.setViewControllers([viewController], animated: animated)
    }
    
    func push(viewController: UIViewController) {
        viewController.navigationItem.backBarButtonItem = backButtonItemProducer()
        baseNavigationController.pushViewController(viewController, animated: true)
    }
    
    func present(viewController: UIViewController) {
        viewController.navigationItem.backBarButtonItem = backButtonItemProducer()
        baseNavigationController.present(viewController, animated: true)
    }
    
    func pop() {
        baseNavigationController.popViewController(animated: true)
    }
    
}
