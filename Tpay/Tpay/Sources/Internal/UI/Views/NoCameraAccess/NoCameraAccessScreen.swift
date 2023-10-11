//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class NoCameraAccessScreen: Screen {
    
    // MARK: - Properties

    lazy var viewController: UIViewController = {
        let controller = UIAlertController(title: Strings.noCameraAccessTitle,
                                           message: Strings.noCameraAccessDescription,
                                           preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: Strings.openApplicationSettings, style: .default) { _ in
            try? DefaultUserApplicationsInteractor().open(.custom(UIApplication.openSettingsURLString))
        })
        controller.addAction(UIAlertAction(title: Strings.close, style: .default, handler: nil))
        
        return controller
    }()
    
}
