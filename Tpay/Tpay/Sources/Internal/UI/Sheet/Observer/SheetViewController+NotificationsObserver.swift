//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension SheetViewController {
    
    final class NotificationsObserver {
        
        // MARK: - Events
        
        let state = Observable<OccupationState>()
        
        // MARK: - Initialization
        
        init() {
            NotificationCenter.default.addObserver(self, selector: #selector(handleState(notification:)), name: Notifications.moduleIsBusy, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleState(notification:)), name: Notifications.moduleIsIdle, object: nil)
        }
        
        deinit {
            Logger.info("SheetViewController.NotificationsObserver deinited")
            NotificationCenter.default.removeObserver(self)
        }
        
        // MARK: - Private
        
        @objc private func handleState(notification: Notification) {
            if notification.name == Notifications.moduleIsBusy {
                state.on(.next(.busy))
            } else if notification.name == Notifications.moduleIsIdle {
                state.on(.next(.idle))
            }
        }
    }
}
