//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension DefaultNavigationController {
    
    final class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
        
        // MARK: - Properties
        
        private let didShowSubscriptionsCache: NSMapTable<AnyObject, DidShowClosureContainer> = NSMapTable.weakToStrongObjects()
        
        // MARK: - Internal
        
        func didShow<Observer: AnyObject>(on observer: Observer, didShow: @escaping (Observer, UIViewController) -> Void) {
            let container = DidShowClosureContainer { [weak observer] viewController in
                if let strongObserver = observer { didShow(strongObserver, viewController) }
            }
            didShowSubscriptionsCache.setObject(container, forKey: observer)
        }
        
        // MARK: - UINavigationControllerDelegate
        
        func navigationController(
            _ navigationController: UINavigationController,
            didShow viewController: UIViewController,
            animated: Bool
        ) {
            didShowSubscriptionsCache
                .objectEnumerator()?
                .allObjects
                .compactMap { object in object as? DidShowClosureContainer }
                .forEach { [weak viewController] container in
                    guard let controller = viewController else { return }
                    container.closure(controller)
                }
        }
        
    }
    
}

extension DefaultNavigationController.NavigationControllerDelegate {
    
    private final class DidShowClosureContainer {
        
        // MARK: - Properties
        
        let closure: (UIViewController) -> Void
        
        // MARK: - Initializers
        
        init(closure: @escaping (UIViewController) -> Void) {
            self.closure = closure
        }
        
    }
    
}
