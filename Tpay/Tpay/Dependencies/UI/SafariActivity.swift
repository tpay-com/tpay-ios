//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class SafariActivity: UIActivity {

    // MARK: - Properties

    private let application: UIApplication
    private let url: URL

    // MARK: - Getters

    override var activityType: UIActivity.ActivityType { .openInSafari }
    override var activityTitle: String? { "Open in Safari" }

    override var activityImage: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "safari")?.applyingSymbolConfiguration(.init(scale: .large))
        } else {
            return UIImage(named: "Safari")
        }
    }

    // MARK: - Initializers
    
    init(url: URL, in application: UIApplication) {
        self.application = application
        self.url = url
    }
    
    // MARK: - API
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        application.canOpenURL(url)
    }

    override func perform() {
        application.open(url)
        activityDidFinish(true)
    }

}
