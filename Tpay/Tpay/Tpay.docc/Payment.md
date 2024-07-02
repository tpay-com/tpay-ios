# Payment

Creating and processing payment transactions.

## Create a transaction

You can create a transaction using the ``SingleTransaction`` struct specifying the transaction's amount and description. 

```swift
let singleTransaction = SingleTransaction(amount: 50.0, description: "Product Purchase")
```

### Payer context

The payer context provides information about the payer, including their personal details and automatic payment methods. You can pass it along with transaction details.

```swift
let payer = Payer(name: "John Doe", email: "john@example.com")
let payerContext = PayerContext(payer: payer, automaticPaymentMethods: nil)
let singleTransaction = SingleTransaction(amount: 50.0, description: "Product Purchase", payerContext: payerContext)
```

> Note: See <doc:AutomaticPaymentMethods> page describing how to provide automatic payment methods for a specific payer.

### Recursive transaction

For recurring transactions, you shall create an instance of ``RecursiveTransaction`` specifying recursion parameters such as the frequency, quantity, and expiry date.

```swift
let recursiveTransaction = RecursiveTransaction(wrapping: singleTransaction,
                                                frequency: .monthly,
                                                quantity: .count(5),
                                                expiryDate: futureDate)
```

## Payment sheet

The ``Payment/Sheet`` is designed to guide the user through the payment process. Payment sheet is presented in a modal style, providing a focused and intuitive payment interaction. The class interacts with the provided ``PaymentDelegate`` to notify about payment events.

To create an instance of the `Sheet` class, initialize it with a `Transaction` object and an optional `PaymentDelegate`:

```swift
let paymentSheet = Payment.Sheet(transaction: transaction, delegate: delegate)
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

### SwiftUI way

```swift
struct ContentView: View {
    @State private var isPaymentSheetPresented = false

    var body: some View {
        Button("Pay") {
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

## Headless

An alternative method for incorporating payments into an application is available. This approach empowers developers to autonomously gather all necessary payer information, facilitating the invocation of methods to programmatically initiate and advance through payment transactions, all without relying on a dedicated user interface (Payment Sheet).

Initially, retrieve the list of available payment channels:

```swift
Headless.getAvailablePaymentChannels { result in
    switch result {
    case .success(let paymentChannels):
        // Handle available payment channels
    case .failure(let error):
        // Handle error
    }
}
```

Once you have the list of available payment channels, choose the desired channel and execute the relevant method with the appropriate arguments:

```swift
do {
    Headless.invokePayment(for: transaction, using: cardPaymentChannel, with: card) { result in
        switch result {
        case .success(let paymentResult):
            // Handle payment result
        case .failure(let error):
            // Handle error
        }
    }
} catch {
    // Handle invocation errors or other exceptions
}
```

After successful payment invocation, you can retrieve the current payment status using:

```swift
Headless.getPaymentStatus(for: paymentResult.ongoingTransaction) { statusResult in
    switch statusResult {
    case .success(let paymentStatus):
        // Handle payment status
    case .failure(let statusError):
        // Handle status retrieval error
    }
}
```

## Payment WebView 

You can easily handle externally generated transactions with a WebView component.
In order to generate a tranaction, please follow `Transactions` section under [OpenAPI documentation](https://openapi.tpay.com).

```swift
let transaction = ExternallyGeneratedTransaction(transactionPaymentUrl: transactionPaymentUrl,  // retrieved from POST /transactions
                                                 onSuccessRedirectUrl: onSuccessUrl,            // must match the one sent on transaction create
                                                 onErrorRedirectUrl: onErrorUrl)                // must match the one sent on transaction create

let paymentWebView = Payment.WebView(transaction: transaction, delegate: delegate)
do {
    try paymentWebView?.present(from: self)
} catch {
    // Handle configuration errors or other exceptions
}
```

## Topics

- ``Headless``

### Classes

- ``Payment/Sheet``
- ``Payment/Button``
- ``Payment/WebView``

### Protocols

- ``PaymentDelegate``
