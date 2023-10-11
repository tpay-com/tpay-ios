//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Combine
import UIKit

protocol ViewControllerPresenter {
    
    var rootViewController: UIViewController { get }
    
    // MARK: - API
    
    func removeFromStack(_ viewController: UIViewController)
    
    func didShow<Observer: AnyObject>(viewController: UIViewController, on observer: Observer, didShow: @escaping (Observer) -> Void)
    
    func show(_ viewController: UIViewController)
    
    func show(_ viewController: UIViewController, then: @escaping () -> Void)
    
    func push(_ viewController: UIViewController)
    
    func push(_ viewController: UIViewController, then: (() -> Void)?, onBack: (() -> Void)?)
    
    func dismiss()
    func pop()
    func pop(to viewController: UIViewController)
    
    func presentPageSheet(_ viewController: UIViewController)
    
    /// Presents view controller as full screen modal
    /// - Parameter viewController: presented view controller
    func presentFullScreen(_ viewController: UIViewController)
    
    /// Presents view controller modally
    /// - Parameter viewController: presented view controller
    func presentModally(_ viewController: UIViewController)
}
