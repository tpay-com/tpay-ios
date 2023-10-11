# Basics

How to start.

To start using the Tpay SDK, you'll primarily interact with the methods provided by the ``TpayModule`` API. This API encapsulates essential configuration steps, transaction management, and further interaction with the Tpay payment ecosystem.

## Merchant configuration

Configuring a merchant is an essential step when integrating the Tpay SDK into your app. A merchant configuration provides the necessary details for processing payments and establishing a connection with Tpay's payment ecosystem.

### Authorization details

Collect the merchant's authorization details, such as the `clientId` and `clientSecret`. You can create an instance of ``Merchant/Authorization`` with these details:

```swift
let authorization = Merchant.Authorization(clientId: "your_client_id", clientSecret: "your_client_secret")
```

### Merchant

Now, create a `Merchant` instance by combining the `authorization` with other optional configurations such as `cardsConfiguration`, `blikConfiguration`, and more. Here's an example of creating a basic `Merchant` configuration:

```swift
let merchant = Merchant(authorization: authorization)
```

You can customize the ``Merchant`` instance further based on your app's requirements.

Use the ``TpayModule/configure(merchant:)`` method to set up the merchant configuration within the Tpay SDK:

```swift
do {
    try TpayModule.configure(merchant: merchant)
    // Configuration successful
} catch {
    // Handle configuration errors
}
```

### Merchant details

Create a type conforming to the ``MerchantDetailsProvider`` protocol by implementing its required methods. Provide localized versions for each part of the information. This strings will appear on the Tpay module screens and are required to satisfy GDPR requirements. For example:

```swift
class MyMerchantDetailsProvider: MerchantDetailsProvider {
    func merchantDisplayName(for language: Language) -> String {
        // Return the merchant's display name based on the specified language
    }
    
    func merchantHeadquarters(for language: Language) -> String? {
        // Return the merchant's headquarters location based on the specified language
    }
    
    func regulationsLink(for language: Language) -> URL {
        // Return the URL to the regulations page based on the specified language
    }
}
```

Use the ``TpayModule/configure(merchantDetailsProvider:)`` method to set up the merchant details provider:

```swift
TpayModule.configure(merchantDetailsProvider: myMerchantDetailsProvider)
```

### Available payment methods

The Tpay SDK supports a range of payment methods, including credit cards, BLIK, digital wallets, and more. By configuring the available payment methods, you can control which options are presented to users during the payment process.

Create an array of desired payment methods you want to offer to users:

```swift
let paymentMethods: [PaymentMethod] = [.card, .blik, .digitalWallet(.applePay)]
```

Use the ``TpayModule/configure(paymentMethods:)`` method to set up the available payment methods:

```swift
do {
    try TpayModule.configure(paymentMethods: paymentMethods)
    // Configuration successful
} catch {
    // Handle configuration errors
}
```

If not specified, module will present all payment methods by default.

> Important: Some payment methods may require additional setup to make them run succesfully.
See: ``Merchant/CardsAPI``, ``Merchant/WalletConfiguration/ApplePayConfiguration``.

### Languages support

Use the ``TpayModule/configure(preferredLanguage:supportedLanguages:)`` method to set up the language preferences:

```swift
do {
    try TpayModule.configure(preferredLanguage: .en, supportedLanguages: .allCases)
    // Configuration successful
} catch {
    // Handle configuration errors
}
```

If not specified, module will support all implemented languages (see: ``Language``) and will start in `.pl` language by default.

### Security (SSL pinning)

The Tpay SDK's `TpayModule` offers the capability to enhance the security of your app's communication with Tpay's servers by implementing SSL pinning. SSL pinning is a security technique that ensures your app only communicates with servers that possess specific SSL certificates, guarding against potential security vulnerabilities.

SSL pinning involves comparing a server's SSL certificate with a pre-defined certificate or a set of trusted certificates. By configuring SSL pinning via the `TpayModule`, you strengthen the security of the connection between your app and Tpay's servers, reducing the risk of data interception or tampering.

In order to configure SSL pinning, create a type conforming to the ``SSLCertificatesProvider`` protocol by implementing its required methods and pass it via ``TpayModule/configure(sslCertificatesProvider:)`` method:

```swift
TpayModule.configure(sslCertificatesProvider: sslProvider)
```

### Setup validation

The `TpayModule` provides a convenient method to check the overall configuration of your app's payment settings. The configuration check method helps ensure that all required parameters and settings are properly configured before initiating payment processes, reducing the likelihood of errors and providing a smoother user experience.

```swift
do {
    try TpayModule.configure(merchant: merchant)
        .configure(paymentMethods: paymentMethods)
        .configure(sslCertificatesProvider: sslProvider)
        .configure(merchantDetailsProvider: detailsProvider)
        .configure(preferredLanguage: .en, supportedLanguages: [.en, .pl])
    // Configuration chain completed successfully
} catch {
    // Handle configuration errors
}

let configurationCheckResult = TpayModule.checkConfiguration()

switch configurationCheckResult {
case .valid:
    // Configuration is complete and valid, proceed with payment processes
case .invalid(let error):
    // Configuration is invalid, handle the specific error accordingly
}
```

> Tip:
You can chain multiple configuration methods.

> Note:
Now you are ready to start using main Tpay module features: <doc:Payment>, <doc:CardTokenization>.
