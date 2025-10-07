//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension SheetViewController {
    
    final class NotificationsObserver {
        
        // MARK: - Events
        
        let state = Observable<OccupationState>()
        
        // MARK: - Initialization
        
        init() {
            NotificationCenter.default.addObserver(self, selector: #selector(handleState(notification:)), name: UINotifications.moduleIsBusy, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleState(notification:)), name: UINotifications.moduleIsIdle, object: nil)
        }
        
        deinit {
            Logger.info("SheetViewController.NotificationsObserver deinited")
            NotificationCenter.default.removeObserver(self)
        }
        
        // MARK: - Private
        
        @objc private func handleState(notification: Foundation.Notification) {
            if notification.name == UINotifications.moduleIsBusy {
                state.on(.next(.busy))
            } else if notification.name == UINotifications.moduleIsIdle {
                state.on(.next(.idle))
            }
        }
    }
}
