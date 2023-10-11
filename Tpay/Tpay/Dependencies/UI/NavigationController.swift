//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

protocol NavigationController: ViewController {
    
    // MARK: - Properties
    
    var baseNavigationController: UINavigationController { get }
    
    // MARK: - API
    
    func didShow<Observer: AnyObject>(on observer: Observer, didShow: @escaping (Observer, UIViewController) -> Void)
    
    func showNavigationBar()
    func hideNavigationBar()
    
    func prefersLargeTitles()
    func setLargeTitleIndent(_ indent: CGFloat)
    
    func show(viewController: UIViewController)
    func push(viewController: UIViewController)
    func present(viewController: UIViewController)
    func pop()
    
}
