# Tpay

[![Min](https://img.shields.io/badge/12.0-informational.svg?logo=ios)](https://shields.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## About

This SDK allows your app to make payments with Tpay.
Package documentation is available [here](https://tpay-com.github.io/tpay-ios/documentation/tpay/).

Minimum supported versions:

| Library | Version |
|---------|---------|
| iOS     | 12.0    |

> [!warning]
> For this SDK to work you will need `client_id` and `client_secret` tokens. You can find
> in [merchant's panel](https://panel.tpay.com/?lang=1).
>
> If you are partner, you can obtain them in your merchant partner account. For detailed
> instructions how to do that or how to create such an account
> check [this site](https://docs-api.tpay.com/en/merchant-accounts/).

> [!tip]
> To be able to test the SDK properly,
> use [mock data](https://support.tpay.com/sprzedawca/srodowisko-testowe-sandbox).

## Install

How to install the SDK.

### SPM

```
File > Swift Packages > Add Package Dependency
Add https://github.com/tpay-com/tpay-ios.git
Select "Up to Next Major" with "1.0.0"
```

### CocoaPods

```ruby
use_frameworks!

target :MyTarget do
  pod 'Tpay-SDK'
end
```

Once you have completed your Podfile, simply run `pod install`.

### Manually

Simply, drag the `Tpay.xcframework` into the `Frameworks, Libraries and Embedded Content` section of
your target.

## Import

To begin, make sure you have imported the `Tpay` framework into your project. You can do this by
adding the following line at the top of your Swift file:

```swift
import Tpay
```

## Configuration

> [!note]
> In this section we will provide examples for each configuration to the TpayModule class
> you will be able to make.

> [!important]
> Beneath you will find all configurations that are **MANDATORY**.

### Initialization

At first, you have to configure your app to be able to make any requests by providing SDK info about
your merchant account.
Info about `client_id` and `client_secret` you will find in your merchant's panel at `Integration ->
API`.

```swift
TpayModule.configure(
    merchant: Merchant(
        authorization: Merchant.Authorization(
            clientId: "client_id",
            clientSecret: "client_secret",
        ),
    )
)
```

### Environment

Tpay SDK provides two types of environments you can use in your app:

* `Environment.sandbox` - used only for tests and in stage/dev flavor.
* `Environment.production` - used for production flavors.

```swift
TpayModule.configure(
    merchant: Merchant(
        authorization: Merchant.Authorization(
            clientId: "client_id",
            clientSecret: "client_secret",
        ),
        environment: .sandbox,
    )
)
```

### Payment methods

For users to be able to use a specific payment method you have declared it in the configuration.

| Method                      | Description                                                              |
|-----------------------------|--------------------------------------------------------------------------|
| BLIK                        | [Web docs](https://docs-api.tpay.com/en/payment-methods/blik/)           |
| Pbl **(Pay-By-Link)**       | [Web docs](https://docs-api.tpay.com/en/payment-methods/pbl/)            |
| Card                        | [Web docs](https://docs-api.tpay.com/en/payment-methods/cards/)          |
| DigitalWallets              | [APPLE_PAY](https://docs-api.tpay.com/en/payment-methods/apple-pay/)     |
| InstallmentPayments         | [RATY_PEKAO](https://docs-api.tpay.com/en/payment-methods/installments/) |
| DeferredPayments **(BNPL)** | [PAY_PO](https://docs-api.tpay.com/en/payment-methods/bnpl/)             |

> [!note]
> As default, if no method were provided, all methods are being set up.

<br>

```swift
TpayModule.configure(
    paymentMethods: [
        PaymentMethod.card,
        PaymentMethod.blik,
        PaymentMethod.payPo,
        PaymentMethod.pbl,
        PaymentMethod.digitalWallet(DigitalWallet.applePay),
        PaymentMethod.installmentPayments(InstallmentPayment.ratyPekao),
    ],
)
```

### Card

If you decide to enable the credit card payment option, you have to provide SSL certificates.

> [!tip]
> You can find public key on you merchant panel:
> - Acquirer Elavon: `Credit card payments -> API`
> - Acquirer Pekao: `Integrations -> API -> Cards API`

At first, create your own implementation of `SSLCertificatesProvider`:

```swift
struct SSLCertProvider: SSLCertificatesProvider {
    var apiConfiguration: Tpay.CertificatePinningConfiguration = CertificatePinningConfiguration(
        publicKeyHashes: ["ssl_cert_hash"],
    )
}
```

then, simply use it in the `TpayModule.configure` func.

```swift
TpayModule.configure(
    sslCertificatesProvider: SSLCertProvider()
)
```

### Apple Pay configuration

In order to be able to use Apple Pay method you have to provide your `merchant_id` and `country_code` to the SDK.
Both those information, you just put in the merchant configuration object with `walletConfiguration` field.

> [!important]
> To obtain the merchantIdentifier, follow these steps:
> 1. Log in to your Apple Developer account.
> 2. Navigate to the `Certificates, Identifiers & Profiles` section.
> 3. Under `Identifiers,` select `Merchant IDs.`
> 4. Click the `+` button to create a new Merchant ID.
> 5. Fill in the required information and associate it with your app's Bundle ID.
> 6. Once created, the merchant identifier can be found in the list of Merchant IDs.
> 7. For more details, please follow [Apple Pay documentation](https://developer.apple.com/documentation/passkit/apple_pay/setting_up_apple_pay).

> [!tip]
> As for the country code, SDK provides predefined `CountryCode.pl` value.
> For more codes, check our `CountryCode.init` func.

```swift
TpayModule.configure(
    merchant: Merchant(
        // previous config,
        walletConfiguration: Merchant.WalletConfiguration.init(
            applePayConfiguration: Merchant.WalletConfiguration.ApplePayConfiguration(
                merchantIdentifier: "merchant_id",
                countryCode: Merchant.WalletConfiguration.ApplePayConfiguration.CountryCode.pl,
            ),
        )
    )
)
```

### Merchant details

As a merchant, you can configure how information about you will be shown.
You can set up your `display name`, `headquarters` and `regulations link`.
You can choose to provide different copy for each language or simply use one for all.

At first, create your own implementation of `MerchantDetailsProvider`:

```swift
struct MerchantDetails: MerchantDetailsProvider {
    func merchantDisplayName(for language: Tpay.Language) -> String {
        let displayName = switch language {
            case Language.pl:
                "Sprzedawca"
            
            case Language.en:
                "Merchant"
            
            default :
                 "Unknown"
        }
        
        return displayName
    }
    
    func merchantHeadquarters(for language: Tpay.Language) -> String? {
        let displayName = switch language {
        case Language.pl:
            "Warszawa"
            
        case Language.en:
            "Warsaw"
            
        default :
            "City"
        }
        
        return displayName
    }
    
    func regulationsLink(for language: Tpay.Language) -> URL {
        let displayName = switch language {
        case Language.pl:
            URL.init(string: "regulations_link/pl")
            
        case Language.en:
            URL.init(string: "regulations_link/en")
            
        default :
            URL.init(string: "regulations_link")
        }
        
        return displayName!
    }
}
```

then, simply use it in the `TpayModule.configure` func.

```swift
TpayModule.configure(merchantDetailsProvider: MerchantDetails())
```

### Wallet Configuration

> [!important]
> Beneath you will find all configurations that are **OPTIONAL**.

### Languages

Tpay SDK lets you decide what languages will be available in the Tpay's screen and which one of them
will be preferred/default.

Right now, SDK allows you to use 2 languages:

* `Language.pl` - polish
* `Language.en` - english

> [!warning]
> If you do not choose to configure languages at all, by default, all available languages will be
> supported and polish will be preferred one.

```swift
TpayModule.configure(
    preferredLanguage: Language.pl,
    supportedLanguages: [Language.pl, Language.en],
)
```

### Callbacks

Tpay SDK allows you to add your custom callbacks, which includes `successRedirectUrl`, `errorRedirectUrl`, `notificationsUrl` and `notificationEmail`.

> [!warning]
> `notificationUrl` should be the URL handled by your backend, because there will be sent token from
> the successful token creation.

```swift
TpayModule.configure(
    callbacks: CallbacksConfiguration(
        successRedirectUrl:  URL.init(string: ""),
        errorRedirectUrl: URL.init(string: ""),
        notificationsUrl: URL.init(string: ""),
        notificationEmail:  "",
    ),
)
```

### Checking configuration

To wrap up whole configuration and therefore install it, you have to use `checkConfiguration` func and check for the configuration result.

```swift
let configResult = TpayModule.checkConfiguration()

switch configResult {
case .valid:
    // Configuration is complete and valid, proceed with payment processes
case .invalid(let error):
    // Configuration is invalid, handle the specific error accordingly
@unknown default:
    print("Unknown case")
    // Handle default value
}
```

## Handling payments

> [!warning]
> Beofre using any payment method, you **HAVE TO** configure the TpayModule using `checkConfiguration` func.

Tpay SDK provides two ways of handling payments:

- `Official SDK screens` - you can use Tpay's official screens where you just need to provide "soft"
  information, like price, description or payer info.
- `Screenless` - you can use screenless functionalities, where you set callbacks for payments and
  display all necessary information on your own screens.
  
## Official SDK screens

> [!warning]
> Screens made by the Tpay team are based on UIViewController system!

To make integration with the SDK faster, we created 4 types of sheets that can be used to handle
payments:

* `Payment` - the most simple screen where the user can choose any payment method and proceed with it.
* `AddCard` - screen that handles generating payment token from the credit card.
* `CardTokenPayment` - screen that handles payment with a previously created token for a credit card.
* `Payment.WebView` - screens that handle payment through webview with a specific link generated via API.

### Delegate

Each payment gives you a way of reacting to it's result. Simply, create and use instance of `PaymentDelegate`.

```swift
class PaymentResultDelegate : PaymentDelegate {
    func onPaymentCreated(transactionId: Tpay.TransactionId) {
        print("Created")
    }
    
    func onPaymentCompleted(transactionId: Tpay.TransactionId){
        print("Completed")
    }
    
    func onPaymentCancelled(transactionId: Tpay.TransactionId){
        print("Cancelled")
    }
    
    func onPaymentClosed(){
        print("Closed")
    }
    
    func onErrorOccured(error: any Tpay.ModuleError){
        print("Error: \(error.localizedDescription)")
    }
}
```

### Payment

Payment flow opens a UI module and allows the customer to pick one of defined the payment methods.
This method requires setting up a few things in order to fulfill payment:

* `amount` - simply the price of the transaction
* `description` - transaction description
* `hiddenDescription` (optional) - description visible only to the merchant
* `payerContext` - information about payer
    * `payer` - information about the person who is making the payment
        * `name` - payer name
        * `email` - payer email
        * `phone` - payer phone number
        * `address` - payer address
            * `city` - city name
            * `country` - country code in ISO 3166-1 alpha-2 format
            * `address` - street address
            * `postalCode` - postal code
    * `automaticPaymentMethods` - (optional) configuration of automatic payments
        * `tokenizedCards` - previously saved credit cards
            * `token` - card token
            * `cardTail` - last 4 digits of the card
            * `brand` - card brand
        * `registeredBlikAlias` - previously saved BLIK alias
            * `value` - alias value
            * `label` - alias label

#### Transaction

```swift
SingleTransaction(
    amount: 250,
    description: "test",
    hiddenDescription: "hidden message",
    payerContext: PayerContext(
        payer: Payer(
            name: "Test",
            email: "email@address.com",
        ),
    ),
  )
```

#### Display with code

The Payment/Sheet is designed to guide the user through the payment process. Payment sheet is presented in a modal style, providing a focused and intuitive payment interaction. The class interacts with the provided PaymentDelegate to notify about payment events.

```swift
Payment.Sheet(
    transaction: SingleTransaction(
        amount: 250,
        description: "test",
        hiddenDescription: "hidden message",
        payerContext: PayerContext(
            payer: Payer(
                name: "Test",
                email: "email@address.com",
            ),
        ),
    ), 
    delegate: PaymentResultDelegate(),
)
```

Use the ``Payment/Sheet/present(from:)`` method to present the payment sheet from a view controller:

```swift
do {
    try paymentSheet.present(from: presentingViewController)
} catch {
    // Handle configuration errors or other exceptions
}
```

To dismiss the payment sheet manually, call the `dismiss()` method:

```swift
paymentSheet.dismiss()
```

#### Display with SwiftUI

To make your life easier and fasten our SDK implementation, we also provide a way of presenting Payment modal with simple button's extension func.

```swift
struct ContentView: View {
    @State private var isPaymentSheetPresented = false

    var body: some View {
        Button("Show Payment modal") {
            isPaymentSheetPresented.toggle()
        }
        .presentPaymentSheet(for: transaction, isPresented: $isPaymentSheetPresented) { transactionId in
            // Handle payment completed
        } onPaymentCancelled: { transactionId in
            // Handle payment cancelled
        } onErrorOccured: { error in
            // Handle payment error
        }
    }
}
```

#### Automatic Payments

Using `Payment.Sheet` screen you can set up automatic BLIK or card payments.
Thanks to that, user will not have to enter BLIK/card data all over again each time making the
payment.

##### Automatic Card Payments

If a user using a card as a payment method will opt-in saving card, on successful payment, on the link
specified as `notificationUrl`, Tpay backend will send information about saved card token, tail and
brand.
Next, your backend has to send it to you, so you can use this info next time the same user wants
to pay with the card.
When you already have all required information, you can add `automaticPaymentMethods` to the
`payerContext`.

```swift
automaticPaymentMethods: .init(
    tokenizedCards: [
        CardToken(token: "token", cardTail: "1234", brand: .visa),
    ],
),
```

##### Automatic BLIK Payments

If a user using BLIK as a payment method will opt-in saving BLIK alias, next time the same user will
want to pay with BLIK, you can simply use a previously saved alias to make the payment even faster.
When you already have all the required information, you can add `automaticPaymentMethods` to the
`payerContext`.

```swift
let blikConfiguration = Merchant.BlikConfiguration(aliasToBeRegistered: .init(value: .uid("myBlikAlias")))
let merchant = Merchant(authorization: authorization, blikConfiguration: blikConfiguration)
```

Next, after successfuly registering your alias, you can use it in a the transaction like so:

```swift
automaticPaymentMethods: .init(
    registeredBlikAlias: RegisteredBlikAlias(value: .uid("myBlikAlias")),
),
```

#### Recurring Payment

Payment class lets you use recurring payments as well. To do so, simply use `RecursiveTransaction` class.

> [!important]
> You can choose one of the specified recurring payment frequencies:
> `.daily`, `.weekly`, `.monthly`,`.quarterly` or `.yearly`.

> [!important]
> You can choose to either charge user specified times using `Quantity.specified` option,
> or to set it up to being charged until expiration date is being hit or user cancels subscription
> on his own with `Quantity.indefinite`.

```swift
RecursiveTransaction(
    wrapping: SingleTransaction(
        amount: 250,
        description: "test",
        hiddenDescription: "hidden message",
        payerContext: PayerContext(
            payer: Payer(
                name: "Test",
                email: "email@address.com",
            ),
        ),
    ),
    frequency: .monthly,
    quantity: .specified(5),
    expiryDate: Date(),
)
```

## Tokenization

Tpay SDK allows you to make credit card transactions without need of entering card's data each time.
Instead, you can create and use a token, associated with a specific card and user.

> [!important]
> There are 2 types of tokens you can use in transactions:
> * [Simple tokens](https://docs-api.tpay.com/en/tokenization/#tokenization-without-charging) -
    tokens that go with card data upon transaction.
> * [Network tokens](https://docs-api.tpay.com/en/tokenization/#tokenization-plus) -
    tokens that can be used without exposing the card details. Also, this token persists even if
    card expires and the user requests a new one.

> [!warning]
> This view only allows creating card token,
> to make an actual payment, you have to then use it in the `Payment.Sheet`.

> [!warning]
> For recurring payments, you can simply use created token in the authomatic payments
> to make transaction without need of user interaction.

### Creating card token

The AddCard/Sheet is designed to guide the user through the card tokenization process. Sheet is presented in a modal style, providing a focused and intuitive interaction. The class interacts with the provided AddCardDelegate to notify about tokenization events.

```swift
let addCardSheet = AddCard.Sheet(
    payer: Payer(
        name: "Test",
        email: "email@address.com",
    ),
    delegate: PaymentResultDelegate(),
)
```

> [!warning]
> Card token will be sent to the url provided in the `merchant configuration` -> `callbacks` -> `notificationsUrl`

### Display with code

Use the AddCard/Sheet/present(from:) method to present the sheet from a view controller:

```swift
do {
    try addCardSheet.present(from: presentingViewController)
} catch {
    // Handle configuration errors or other exceptions
}
```

To dismiss the sheet manually, call the dismiss() method:

```swift
addCardSheet.dismiss()
```

### Display with SwiftUI

```swift
struct ContentView: View {
    @State private var isTokenizationSheetPresented = false

    var body: some View {
        Button("Add Card") {
            isTokenizationSheetPresented.toggle()
        }
        .presentCardTokenizationSheet(isPresented: $isTokenizationSheetPresented) {
            // Handle card tokenization completed
        } onTokenizationCancelled: {
            // Handle card tokenization cancelled
        } onErrorOccured: { error in
            // Handle tokenization error
        }
    }
}
```

## Web view

Tpay SDK provides you also way of handling transactions via WebView. During configuration, you have to
provide 3 URL links:

1) `transactionPaymentUrl` - for the user to make an actual payment.
2) `onSuccessRedirectUrl` - for redirecting the user to the success page.
3) `onErrorRedirectUrl` - for redirecting the user to the failure page.

> [!warning]
> `transactionPaymentUrl` - you or your backend can generate transactionUrl using specific
> [Tpay API endpoint](https://docs-api.tpay.com/en/first-steps/first-transaction/#create-a-transaction).

```swift
let transaction = ExternallyGeneratedTransaction(
    transactionPaymentUrl: transactionPaymentUrl,
    onSuccessRedirectUrl: onSuccessUrl,
    onErrorRedirectUrl: onErrorUrl,
)

let paymentWebView = Payment.WebView(
    transaction: transaction,
    delegate: delegate,
)

do {
    try paymentWebView?.present(from: self)
} catch {
    // Handle configuration errors or other exceptions
}
```

### Webview Delegate

Webview delegate differs from simple transaction delegate

```swift
class WebviewResultDelegate: WebViewPaymentDelegate {
    func onPaymentCompleted() {
        // On payment completed
    }
    
    func onPaymentCancelled() {
        // On payment cancelled
    }
    
    func onPaymentError() {
        // On payment error
    }
}
```

## Screenless Payments

Screenless payments are a special type of payment functionality that gives you the whole power of
payment process, but do not limit you to using predefined Tpay screens.

### Get payment channels

To be able to use screenless functionalities you will need to know which payment methods are
available to your merchant account. To get them, you can simply call `Headless.getAvailablePaymentChannels`
and set up result observer for them.

Last but not least, we have to filter them by the specific methods we have enabled in our app and by
the amount of the transaction using.

```swift
Headless.getAvailablePaymentChannels { result in
    switch result {
    case .success(let paymentChannels):
        // Filter payment methods by the transaction amount
    case .failure(let error):
        // Handle error
    }
}
```

> [!important]
> Available methods are being filtered for the specific transaction amount, so you should use this
> functionality each time you want to start a payment process.

### Screenless Credit Card Payment

Tpay SDK allows you to make payment without any predefined screen.
To do so use `Tpay.Headless.Models.Card` class.

```swift
do {
    try Headless.invokePayment(
        for: SingleTransaction(
            amount: 250,
            description: "test",
            hiddenDescription: "hidden message",
            payerContext: PayerContext(
                payer: Payer(
                    name: "Test",
                    email: "email@address.com",
                ),
            ),
        ),
        using: chosenPaymentChannel,
        with: Tpay.Headless.Models.Card(
            number: "4056 2178 4359 7258",
            expiryDate: Headless.Models.Card.ExpiryDate(month: 12, year: 35),
            securityCode: "123",
            shouldTokenize: false,
        )
    ) { result in
        switch result {
        case .success(let paymentResult):
            // Handle payment result
        case .failure(let error):
            // Handle payment error
        }
    }
} catch {
    // Handle invocation errors or other exceptions
}
```

> [!warning]
> If `paymentResult` returns `continueUrl`, you have to handle it
> and redirect user to it in order to complete the payment.

> [!warning]
> If `paymentResult` returns `paid` in `status`,
> it means that transaction has been paid automatically during creation.

> [!warning]
> Generated card token will be sent to `notificationUrl` specified in the notifications callbacks.

#### Tokenization

You can also Opt-in to generate a credit card token for future payments
if you want to let users pay for transactions with previously used card.
To do so, in `Tpay.Headless.Models.Card` class, set the `shouldTokenize` to true.

```swift
with: Tpay.Headless.Models.Card(
    number: "4056 2178 4359 7258",
    expiryDate: Headless.Models.Card.ExpiryDate(month: 12, year: 35),
    securityCode: "123",
    shouldTokenize: true,
)
```

If you already have a credit card token, you can then set up token payment omitting credit card
info.
To do so, use `Tpay.Headless.Models.CardToken` class instead of `Tpay.Headless.Models.Card` one.

```swift
do {
    try Headless.invokePayment(
        for: SingleTransaction(
            amount: 250,
            description: "test",
            hiddenDescription: "hidden message",
            payerContext: PayerContext(
                payer: Payer(
                    name: "Test",
                    email: "email@address.com",
                ),
            ),
        ),
        using: chosenPaymentChannel,
        with: Tpay.Headless.Models.CardToken(
            token: "saved_card_token",
            cardTail: "1234",
            brand: CardToken.Brand.visa,
        )
    ) { result in
        switch result {
        case .success(let paymentResult):
            // Handle payment result
        case .failure(let error):
            // Handle payment error
        }
    }
} catch {
    // Handle invocation errors or other exceptions
}
```

> [!warning]
> For recurring payments, you can simply use created token in the haedless payments
> to make transaction without need of user interaction.

### Screenless BLIK Payment

Tpay SDK let's make transactions with BLIK as well. In order to do so, simply use `Headless.invokePayment` with proper arguments.

```swift
do {
    try Headless.invokePayment(
        for: SingleTransaction(
            amount: 250,
            description: "test",
            hiddenDescription: "hidden message",
            payerContext: PayerContext(
                payer: Payer(
                    name: "Test",
                    email: "email@address.com",
                ),
            ),
        ),
        using: chosenPaymentChannel,
        with: Headless.Models.Blik.Regular(
            token: "777834",
            aliasToBeRegistered: nil,
        ),
    ) { result in
        switch result {
        case .success(let paymentResult):
            // Handle payment result
        case .failure(let error):
            // Handle payment error
        }
    }
} catch {
    // Handle invocation errors or other exceptions
}
```

#### BLIK Alias Payment

If you have for example a returning users and you want to make their payments with BLIK even
smoother,
you can register BLIK Alias for them, so they will only be prompted to accept payment in their
banking app,
without need of entering BLIK code each time they want to make the payment.

In order to do that, you have to pass the alias in the `aliasToBeRegistered` argument.

> [!warning]
> To properly register alias in sandbox, use `amount = 0.15`.

```swift
with: Headless.Models.Blik.Regular(
    token: "777834",
    aliasToBeRegistered: Headless.Models.NotRegisteredBlikAlias(
        value: Headless.Models.NotRegisteredBlikAlias.Value.uid("my_alias")
    )
)
```

If the payment were successful, you can assume an alias was created and can be used for the future
payments.
Next time you want to pay with only an alias, just use `Headless.Models.Blik.OneClick` class instead of the Regular.

```swift
with: Headless.Models.Blik.OneClick(
    registeredAlias: Headless.Models.RegisteredBlikAlias(
        value: Headless.Models.RegisteredBlikAlias.Value.uid("my_alias")
    )
)
```

#### BLIK Ambiguous Alias Payment

Sometimes, there is a possibility for one alias to be registered more than once. For example, if
you register alias associated with one user for the multiple banks.
In such a situation, you have to fetch those aliases from Tpay API and show them to user to let him
choose one for the payment.

In the payment result you can get `BlikPaymentResultWithAmbiguousAliases` type, that will indicate that the current alias was registered more than once.
This result holds all possible variations of the alias you used to start payment with.
You have to simply show them to the user, let him choose, and then use the chosen alias to retry the
payment.

```swift
switch result {
case .success(let paymentResult):
    if paymentResult is Headless.Models.BlikPaymentResultWithAmbiguousAliases {
        let ambiguousAliasesResult = (
            paymentResult as! Headless.Models.BlikPaymentResultWithAmbiguousAliases
        )
        
        showAmbiguousAliases(ambiguousAliasesResult.applications)
    }
case .failure(let error):
    // Handle failure
}
```

> [!warning]
> In such scenario, you have to use different class to make the payment than at the beginning.
> Where `chosenApplication` is the alias's application chosen by user from multiple aliases
> ```swift
> do {
>    try Headless.continuePayment(
>        for: ambiguousAliasesResult.ongoingTransaction,
>        with: Headless.Models.Blik.AmbiguousBlikAlias(
>            registeredAlias: Headless.Models.RegisteredBlikAlias(
>                value: Headless.Models.RegisteredBlikAlias.Value.uid("test_ios")
>            ),
>            application: chosenApplication,
>        )
>    ) { blikResult in
>        switch blikResult{
>        case .success(let result):
>            // Handle amibuous blik payment success
>        case .failure(let error):
>            // Handle amibuous blik payment failure
>        }
>    }
>} catch {
>    // Handle error
>}
> ```

> [!important]
> Right now, Tpay SDK does NOT support recurring payments with BLIK
> In order to achieve that, check
> our [API support for BLIK recurring payments](https://docs-api.tpay.com/en/payment-methods/blik/#blik-recurring-payments).

### Screenless Transfer Payment

Tpay SDK allows you to make transfer payments with bank available to your merchant account.

> [!tip]
> To get banks with their channel ids check
> the [Get Payment Channels](https://docs-api.tpay.com/en/first-steps/list-of-payment-methods/)
> section.
> Then, you have get banks available for you from the available payment methods.

After your customer chooses their bank from the list, you can use it's `channelId` to make the payment.

```swift
Headless.getAvailablePaymentChannels { result in
    switch result {
    case .success(let paymentChannels):
        do {
            let channels = paymentChannels.filter{ channel in
                channel.paymentKind == .pbl
            }
            
            try Headless.invokePayment(
                for: createTransaction(),
                using: channels[12], // replace with user chosen channel from `channels`
            ) { result in
                switch result {
                case .success(let paymentResult):
                    // Handle success
                case .failure(let error):
                    // Handle failure
                }
            }
        } catch {
            // Handle invocation errors or other exceptions
        }
    case .failure(let error):
        // Handle payment channels error
    }
}
```

> [!warning]
> If `paymentResult` returns `continueUrl`, you have to handle it
> and redirect user to it in order to complete the payment.

### Screenless Installment Payments

Tpay SDK allows you to create long term installment payments.

```swift
Headless.getAvailablePaymentChannels { result in
    switch result {
    case .success(let paymentChannels):
        do {
            let channels = paymentChannels.filter{ channel in
                channel.paymentKind == .installmentPayments
            }
            
            try Headless.invokePayment(
                for: createTransaction(),
                using: channels[0], // // replace with installmentPayment channel from `channels`
            ) { result in
                switch result {
                case .success(let paymentResult):
                    // Handle success
                case .failure(let error):
                    // Handle failure
                }
            }
        } catch {
            // Handle invocation errors or other exceptions
        }
    case .failure(let error):
        // Handle payment channels error
    }
}
```

> [!warning]
> If `paymentResult` returns `continueUrl`, you have to handle it
> and redirect user to it in order to complete the payment.

### Screenless Deferred Payments

Tpay SDK allows you to create deferred payments (BNPL) using PayPo method.

> [!warning]
> For PayPo payment to work, amount of the payment must be at least 40PLN!
> For more information about PayPo payments
> check [our PayPo documentation](https://docs-api.tpay.com/en/payment-methods/bnpl/#paypo).

> [!tip]
> For sandbox, working phone number is `500123456`

```swift
Headless.getAvailablePaymentChannels { result in
    switch result {
    case .success(let paymentChannels):
        do {
            let channels = paymentChannels.filter{ channel in
                channel.paymentKind == .payPo
            }
            
            try Headless.invokePayment(
                for: createTransaction(),
                using: channels[0], // replace with PayPo channel from `channels`
            ) { result in
                switch result {
                case .success(let paymentResult):
                    // Handle success
                case .failure(let error):
                    // Handle failure
                }
            }
        } catch {
            // Handle invocation errors or other exceptions
        }
    case .failure(let error):
        // Handle payment channels error
    }
}
```

> [!warning]
> If `paymentResult` returns `continueUrl`, you have to handle it
> and redirect user to it in order to complete the payment.

### Screenless Apple Pay payment

Tpay SDK allows you to perform Apple Pay transactions.

> [!warning]
> To be able to complete Apple Pay payment, you will need `apple_pay_token`. You **HAVE TO**
> acquire a token by yourself. To do that check
> official [Apple Pay documentation](https://developer.apple.com/design/human-interface-guidelines/apple-pay#app-top)

```swift
Headless.getAvailablePaymentChannels { result in
    switch result {
    case .success(let paymentChannels):
        do {
            let channels = paymentChannels.filter{ channel in
                channel.paymentKind == .applePay
            }
            
            try Headless.invokePayment(
                for: createTransaction(),
                using: channels[0], // // replace with ApplePay channel from `channels`
                with: Tpay.Headless.Models.ApplePay(token: "token"),
            ) { result in
                switch result {
                case .success(let paymentResult):
                    // Handle success
                case .failure(let error):
                    // Handle failure
                }
            }
        } catch {
            // Handle invocation errors or other exceptions
        }
    case .failure(let error):
        // Handle payment channels error
    }
}
```

### Screenless Payment Status

If you would need checking payment status in real time, Tpay SDK provides way of doing that.
All you need, is `Tpay.Headless.Models.OngoingTransaction` object from the current transaction.

```swift
Headless.getPaymentStatus(
    for: ongoingTransaction
) { statusResult in
    switch statusResult {
    case .success(let status):
        // Handle new payment status
    case .failure(let error):
        // Handle obtaining payment status failure
    }
}
```

## License

This library is released under the [MIT License](https://opensource.org/license/mit/).
