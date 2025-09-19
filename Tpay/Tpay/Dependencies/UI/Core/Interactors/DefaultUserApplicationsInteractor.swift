//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class DefaultUserApplicationsInteractor: UserApplicationsInteractor {
    
    // MARK: - Properties
    
    private let application: UIApplication
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(application: .shared)
    }
    
    init(application: UIApplication) {
        self.application = application
    }
    
    // MARK: - UrlSchemesManager
    
    func open(_ scheme: UserApplication) throws {
        guard let url = URL(string: scheme.path) else { throw UserApplicationsInteractorError.notSupportedApplication }
        guard application.canOpenURL(url) else { throw UserApplicationsInteractorError.cannotOpenApplication }
        application.open(url)
    }
    
    func share(_ url: URL) {
        let shareController = UIActivityViewController(activityItems: [url], applicationActivities: [SafariActivity(url: url, in: application)])
        application.keyWindow?.rootViewController?.present(shareController, animated: true)
    }
    
}
