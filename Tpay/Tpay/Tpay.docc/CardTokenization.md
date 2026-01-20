# Card tokenization

Saving credit card details for future purchases. 

## Overview

The Tpay SDK provides a way to register a credit card without performing a payment transaction, so a users can define their cards for future OneClick payments.

## AddCard sheet

The ``AddCard/Sheet`` is designed to guide the user through the card tokenization process. Sheet is presented in a modal style, providing a focused and intuitive interaction. The class interacts with the provided ``AddCardDelegate`` to notify about tokenization events.

To create an instance of the `Sheet` class, initialize it with a `Payer` object and an optional `AddCardDelegate`:

```swift
let addCardSheet = AddCard.Sheet(payer: payer, delegate: delegate)
```

Use the ``AddCard/Sheet/present(from:)`` method to present the sheet from a view controller:

```swift
do {
    try addCardSheet.present(from: presentingViewController)
} catch {
    // Handle configuration errors or other exceptions
}
```

To dismiss the sheet manually, call the `dismiss()` method:

```swift
addCardSheet.dismiss()
```

### SwiftUI way

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

## Headless Payment

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

## Topics

### Classes

- ``AddCard/Sheet``
