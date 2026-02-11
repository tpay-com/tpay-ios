//
//  Copyright © 2026 Tpay. All rights reserved.
//

protocol SDKVersionHeadersProvider: HttpHeadersProvider { }

final class DefaultSDKVersionHeadersProvider: SDKVersionHeadersProvider {

    // MARK: - Properties

    private let configurationProvider: ConfigurationProvider

    // MARK: - Initializers

    init(configurationProvider: ConfigurationProvider) {
        self.configurationProvider = configurationProvider
    }

    // MARK: - API

    func headers(for resource: NetworkResource) -> [HttpHeader] {
        let compatibility = configurationProvider.compatibility
        let sdkVersionName = configurationProvider.sdkVersionName

        return [
            XClientSource(compatibility: compatibility, sdkVersionName: sdkVersionName),
            UserAgent(compatibility: compatibility, sdkVersionName: sdkVersionName)
        ]
    }
}
