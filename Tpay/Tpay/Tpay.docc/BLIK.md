## Headless BLIK Payment

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

### BLIK Alias Payment

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

### BLIK Ambiguous Alias Payment

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

### Topics
- ``Headless``

### Classes

- ``Headless/Models/Blik/Regular``
- ``Headless/Models/NotRegisteredBlikAlias``
- ``Headless/Models/RegisteredBlikAlias``
- ``Headless/Models/Blik/OneClick``
- ``Headless/Models/BlikPaymentResultWithAmbiguousAliases``
