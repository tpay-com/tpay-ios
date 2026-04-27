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
