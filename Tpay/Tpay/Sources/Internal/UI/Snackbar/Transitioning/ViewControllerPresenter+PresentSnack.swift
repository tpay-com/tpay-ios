//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension ViewControllerPresenter {
    
    func present(_ snack: Snack) {
        let viewController = SnackbarViewController(snack: snack)
        viewController.modalPresentationStyle = .custom
        rootViewController.present(viewController, animated: true)
    }
}
