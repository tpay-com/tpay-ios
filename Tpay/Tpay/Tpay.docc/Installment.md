## Headless Installment Payments

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
