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

### Headless Payment Status

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

## Topics

- ``Headless``
