# Automatic payments

Providing automatic payment methods for a specific payer.

## Card OneClick payment

The Tpay module gives the user the ability to store credit card details that users can reuse for future payments without the need to re-enter their information.

The payer has the option to save their credit card information either while making a purchase within the payment flow (<doc:Payment>) or through a dedicated <doc:CardTokenization> process.
 
In order to support this feature, please follow `Notifications And Receiving Data After Transaction` section under [OpenAPI documentation](https://openapi.tpay.com).

> Note: This section assumes your app is already in possesion of a payer's card tokens and associated details.

For each payer's tokenized card, create ``CardToken`` instance and pass them with the ``PayerContext``.

```swift
let card = CardToken(token: token, cardTail: tail, brand: brand)
let payerContext = PayerContext(payer: payer,
                                automaticPaymentMethods: .init(tokenizedCards: [card]))
```

## BLIK OneClick payment

To enable BLIK OneClick functionality for users, the first step is to define an alias that will be registered within the BLIK ecosystem when a user is willing to do so.

You can provide one when configuring your `Merchant` using ``Merchant/BlikConfiguration``.

```swift
let blikConfiguration = Merchant.BlikConfiguration(aliasToBeRegistered: .init(value: .uid("myBlikAlias")))
let merchant = Merchant(authorization: authorization, blikConfiguration: blikConfiguration)
```

After receiving a notification about alias registration event (described in `Notifications And Receiving Data After Transaction` section under [OpenAPI documentation](https://openapi.tpay.com)), you can pass it along with the ``PayerContext``.

> Note: This section assumes your app is already in possesion of a payer's registered alias.

```swift
let blikAlias = RegisteredBlikAlias(value: .uid(retrievedAlias))
let payerContext = PayerContext(payer: payer,
                                automaticPaymentMethods: .init(registeredBlikAlias: blikAlias))
```
