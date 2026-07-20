## 1.4.0

- Feature: Add option to enable single transation mode for SDK's official screens

## 1.3.17

- Fix: Resolved EXC_BREAKPOINT crash on `com.tpay.networking` triggered by `getAvailablePaymentChannels()` racing with `configure(merchant:)` (TPS-55). Networking layer no longer calls `preconditionFailure`; race is resolved transparently via wait-for-config (NSCondition + 5s timeout)
- Fix: Three `preconditionFailure` calls in networking layer replaced with proper `NetworkingError` cases (`notConfigured`, `invalidURL`, `invalidResponse`) — never crash the host app on configuration / response edge cases
- Improvement: Wrapped networking validators (ErrorValidator, ResponseValidator, BodyDecoder) into a single concrete class to eliminate boxed-existential captures in dispatched closures
- Tests: +11 unit tests for configuration race + data race stress (33/33 passing)

## 1.3.16

- Feature: Dodano przycisk "wstecz" (chevron) na ekranie 3DS podczas tokenizacji karty — analogicznie do Androida. Po kliknięciu następuje powrót do formularza karty

## 1.3.15

- Fix: Naprawiono wyrównanie kropki w radiobox na urządzeniu (Release/TestFlight)
- Feature: Dodano `notRegisteredBlikAlias` do `AutomaticPaymentMethods` — rejestracja aliasu BLIK na poziomie transakcji (analogicznie jak na Androidzie)

## 1.3.14

- Fix: Resolve race condition crash (EXC_BREAKPOINT in block_destroy_helper) caused by concurrent closure destruction on networking queue
- Fix: Add thread safety to Invocation.Retainer

## 1.3.13

- Fix: Apple Pay radiobox dot alignment on first display
- Fix: Add close button to bank transfer payment webview
