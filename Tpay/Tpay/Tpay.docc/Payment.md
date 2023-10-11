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

## Topics

### Classes

- ``Payment/Sheet``
- ``Payment/Button``

### Protocols

- ``PaymentDelegate``
