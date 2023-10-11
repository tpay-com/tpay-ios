//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class DefaultSceneObserver: SceneObserver {
    
    // MARK: - Properties
     
    private let cache: NSMapTable<AnyObject, ClosureContainer> = NSMapTable.weakToStrongObjects()
    
    // MARK: - Initialization
    
    @available(iOS 13.0, *)
    init(using center: NotificationCenter = .default) {
        center.addObserver(self, selector: #selector(activating), name: UIScene.didActivateNotification, object: nil)
    }
    
    // MARK: - SceneObserver
    
    func notifyActivate<Observer>(on observer: Observer, then: @escaping (Observer) -> Void) where Observer : AnyObject {
        let container = ClosureContainer { [weak observer] in
            if let observer = observer { then(observer) }
        }
        cache.setObject(container, forKey: observer)
    }
    
    //  MARK: - Actions
    
    @objc
    private func activating() {
        cache.objectEnumerator()?.allObjects.compactMap { object in object as? ClosureContainer }.forEach { container in container.closure() }
    }
    
}

extension DefaultSceneObserver {
    
    private final class ClosureContainer {
        
        // MARK: - Properties
        
        let closure: () -> Void
        
        // MARK: - Initializers
        
        init(closure: @escaping () -> Void) {
            self.closure = closure
        }
        
        deinit {
            print("DefaultSceneObserver.ClosureContainer deinited")
        }
        
    }
    
}
