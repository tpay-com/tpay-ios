//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class DefaultKeyboardObserver: KeyboardObserver {
    
    // MARK: - Properties
    
    private let cache: NSMapTable<AnyObject, ClosureContainer> = NSMapTable.weakToStrongObjects()
    
    // MARK: - Initializers
    
    init(using center: NotificationCenter = .default) {
        center.addObserver(self, selector: #selector(keyboardAppearing), name: UIWindow.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDisappearing), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - API
    
    func notifyKeyboardChanges(on view: KeyboardAware) {
        let container = ClosureContainer { [weak view] payload in
            view?.adjust(for: payload)
            
            guard view?.window != .none else { return }
            
            UIView.animate(withDuration: payload.animationDuration, delay: 0, options: payload.animationOptions, animations: { view?.layoutIfNeeded() })
        }
        cache.setObject(container, forKey: view)
    }
    
    func notifyKeyboardChanges<Observer: AnyObject>(on observer: Observer, changes: @escaping (Observer, KeyboardAppearancePayload) -> Void) {
        let container = ClosureContainer { [weak observer] payload in
            if let observer = observer { changes(observer, payload) }
        }
        cache.setObject(container, forKey: observer)
    }
    
    // MARK: - Actions
    
    @objc
    private func keyboardAppearing(_ notification: Foundation.Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        guard let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        
        let data = KeyboardAppearancePayload(mode: .appearing,
                                             height: frame.size.height,
                                             animationDuration: duration.doubleValue,
                                             animationOptions: UIView.AnimationOptions(rawValue: animationCurve.uintValue))
        
        cache.objectEnumerator()?.allObjects.compactMap { object in object as? ClosureContainer }.forEach { container in container.closure(data) }
    }
    
    @objc
    private func keyboardDisappearing(_ notification: Foundation.Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        guard let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        
        let data = KeyboardAppearancePayload(mode: .disappearing,
                                             height: 0,
                                             animationDuration: duration.doubleValue,
                                             animationOptions: UIView.AnimationOptions(rawValue: animationCurve.uintValue))
        
        cache.objectEnumerator()?.allObjects.compactMap { object in object as? ClosureContainer }.forEach { container in container.closure(data) }
    }
    
}

extension DefaultKeyboardObserver {
    
    private final class ClosureContainer {
        
        // MARK: - Properties
        
        let closure: (KeyboardAppearancePayload) -> Void
        
        // MARK: - Initializers
        
        init(closure: @escaping (KeyboardAppearancePayload) -> Void) {
            self.closure = closure
        }
        
        deinit {
            Logger.debug("DefaultKeyboardObserver.ClosureContainer deinited")
        }
        
    }
    
}
