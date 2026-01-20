## Headless Deferred Payments

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
                using: channels[0], // replace with user chosen channel
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

### Topics
- ``Headless``
