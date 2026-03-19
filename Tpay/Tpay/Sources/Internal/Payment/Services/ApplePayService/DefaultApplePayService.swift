//
//  Copyright © 2023 Tpay. All rights reserved.
//

import PassKit

final class DefaultApplePayService: ApplePayService {

    // MARK: - Properties

    private lazy var paymentRequest: PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = configuration.merchantIdentifier
        request.countryCode = configuration.countryCode.rawValue
        request.currencyCode = Domain.Currency.pln.rawValue
        request.supportedNetworks = [.visa, .masterCard]
        request.merchantCapabilities = .capability3DS
        return request
    }()

    private let configuration: Merchant.WalletConfiguration.ApplePayConfiguration
    private let merchantDetailsProvider: MerchantDetailsProvider

    // MARK: - Initializers

    convenience init?(using resolver: ServiceResolver) {
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let configuration = configurationProvider.merchant?.walletConfiguration?.applePayConfiguration,
              let merchantDetailsProvider = configurationProvider.merchantDetailsProvider else { return nil }
        self.init(configuration: configuration, merchantDetailsProvider: merchantDetailsProvider)
    }

    init(configuration: Merchant.WalletConfiguration.ApplePayConfiguration, merchantDetailsProvider: MerchantDetailsProvider) {
        self.configuration = configuration
        self.merchantDetailsProvider = merchantDetailsProvider
    }

    // MARK: - API

    func paymentRequest(for transaction: Domain.Transaction) -> PKPaymentRequest {
        paymentRequest.paymentSummaryItems = [makePaymentItem(from: transaction)]
        return paymentRequest
    }

    // MARK: - Private

    private func makePaymentItem(from transaction: Domain.Transaction) -> PKPaymentSummaryItem {
        let merchantName = merchantDetailsProvider.merchantDisplayName(for: .current)
        return PKPaymentSummaryItem(label: merchantName, amount: NSDecimalNumber(value: transaction.paymentInfo.amount))
    }
}
