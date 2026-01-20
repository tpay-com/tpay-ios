## Headless Apple Pay payment

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
                using: channels[0], // replace with user chosen channel
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

### Topics
- ``Headless``

### Classes
- ``Tpay/Headless/Models/ApplePay``
