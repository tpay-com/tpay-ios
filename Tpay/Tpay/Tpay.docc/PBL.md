## Headless Transfer Payment

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
                using: channels[12], // replace with user chosen channel
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
