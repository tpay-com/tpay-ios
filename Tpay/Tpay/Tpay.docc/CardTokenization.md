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

## Topics

### Classes

- ``AddCard/Sheet``
