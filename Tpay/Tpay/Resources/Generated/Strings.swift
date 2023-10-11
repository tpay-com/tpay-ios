// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum Strings {
  /// Dodaj Kartę
  internal static var addCard: String { Strings.tr("pl", "add_card") }
  /// Dodaj kartę
  internal static var addCardHeadline: String { Strings.tr("pl", "add_card_headline") }
  /// Zapisz kartę
  internal static var addCardSave: String { Strings.tr("pl", "add_card_save") }
  /// Nazwij sklep
  internal static var aliasLabelPlaceholder: String { Strings.tr("pl", "alias_label_placeholder") }
  /// Apple Pay
  internal static var applePay: String { Strings.tr("pl", "apple_pay") }
  /// Wróć
  internal static var back: String { Strings.tr("pl", "back") }
  /// BLIK
  internal static var blik: String { Strings.tr("pl", "blik") }
  /// Wpisz kod BLIK
  internal static var blikCode: String { Strings.tr("pl", "blik_code") }
  /// Nieprawidłowy kod BLIK
  internal static var blikCodeIsInvalid: String { Strings.tr("pl", "blik_code_is_invalid") }
  /// Anuluj
  internal static var cancel: String { Strings.tr("pl", "cancel") }
  /// Karta
  internal static var card: String { Strings.tr("pl", "card") }
  /// Data ważności
  internal static var cardExpiryDate: String { Strings.tr("pl", "card_expiry_date") }
  /// MM/RR
  internal static var cardExpiryDateHint: String { Strings.tr("pl", "card_expiry_date_hint") }
  /// Nieprawidłowa data ważności
  internal static var cardExpiryDateIsInvalid: String { Strings.tr("pl", "card_expiry_date_is_invalid") }
  /// Numer karty
  internal static var cardNumber: String { Strings.tr("pl", "card_number") }
  /// Nieprawidłowy numer karty
  internal static var cardNumberIsInvalid: String { Strings.tr("pl", "card_number_is_invalid") }
  /// CVV2/CVC
  internal static var cardSecurityCode: String { Strings.tr("pl", "card_security_code") }
  /// Nieprawidłowy kod
  internal static var cardSecurityCodeIsInvalid: String { Strings.tr("pl", "card_security_code_is_invalid") }
  /// Wybierz metodę płatności
  internal static var choosePaymentMethod: String { Strings.tr("pl", "choose_payment_method") }
  /// Zamknij
  internal static var close: String { Strings.tr("pl", "close") }
  /// Portfel elektroniczny
  internal static var digitalWallets: String { Strings.tr("pl", "digital_wallets") }
  /// Nieprawidłowy adres email
  internal static var emailIsInvalid: String { Strings.tr("pl", "email_is_invalid") }
  /// Pole wymagane
  internal static var fieldIsRequired: String { Strings.tr("pl", "field_is_required") }
  /// <span>Administratorem danych osobowych jest Krajowy Integrator Płatności spółka akcyjna z siedzibą w Poznaniu. <a href='%@'><b>Zapoznaj się z pełną treścią.</b></a></span>
  internal static func gdprNote(_ p1: String) -> String {
    return Strings.tr("pl", "gdpr_note", p1)
  }
  /// Google Pay
  internal static var googlePay: String { Strings.tr("pl", "google_pay") }
  /// Płacę %@
  internal static func imPaying(_ p1: String) -> String {
    return Strings.tr("pl", "im_paying", p1)
  }
  /// Nieprawidłowa liczba znaków
  internal static var invalidLength: String { Strings.tr("pl", "invalid_length") }
  /// <span>Administratorem danych osobowych jest %@ z siedzibą w %@.</br><a href='%@'><b>Zapoznaj się z pełną treścią.</b></a></span>
  internal static func merchantGdprNoteWithHeadquarters(_ p1: String, _ p2: String, _ p3: String) -> String {
    return Strings.tr("pl", "merchant_gdpr_note_with_headquarters", p1, p2, p3)
  }
  /// <span>Administratorem danych osobowych jest %@.</br><a href='%@'><b>Zapoznaj się z pełną treścią.</b></a></span>
  internal static func merchantGdprNoteWithoutHeadquarters(_ p1: String, _ p2: String) -> String {
    return Strings.tr("pl", "merchant_gdpr_note_without_headquarters", p1, p2)
  }
  /// Nieprawidłowa nazwa płatnika
  internal static var nameIsInvalid: String { Strings.tr("pl", "name_is_invalid") }
  /// Wybór karty
  internal static var navigateToCardSelection: String { Strings.tr("pl", "navigate_to_card_selection") }
  /// Przejdź do ustawień i nadaj wymagane uprawienia dla aplikacji
  internal static var noCameraAccessDescription: String { Strings.tr("pl", "no_camera_access_description") }
  /// Brak dostępu do kamery
  internal static var noCameraAccessTitle: String { Strings.tr("pl", "no_camera_access_title") }
  /// Brak połączenia z internetem
  internal static var noInternetConnection: String { Strings.tr("pl", "no_internet_connection") }
  /// OK
  internal static var ok: String { Strings.tr("pl", "ok") }
  /// Przejdź do ustawień aplikacji
  internal static var openApplicationSettings: String { Strings.tr("pl", "open_application_settings") }
  /// Wybierz swój bank
  internal static var payByLinkHeadline: String { Strings.tr("pl", "pay_by_link_headline") }
  /// Nie musisz podawać kodu BLIK - robisz zakupy w zapisanym wcześniej sklepie.
  internal static var payWithBlikAliasNote: String { Strings.tr("pl", "pay_with_blik_alias_note") }
  /// Dodaj kartę
  internal static var payWithCardHeadline: String { Strings.tr("pl", "pay_with_card_headline") }
  /// Wybierz kartę
  internal static var payWithCardTokenHeadline: String { Strings.tr("pl", "pay_with_card_token_headline") }
  /// Zapłać przy użyciu kodu
  internal static var payWithCode: String { Strings.tr("pl", "pay_with_code") }
  /// Zapłać za pomocą
  internal static var payWithHeadline: String { Strings.tr("pl", "pay_with_headline") }
  /// E-mail
  internal static var payerEmail: String { Strings.tr("pl", "payer_email") }
  /// Imię i nazwisko
  internal static var payerName: String { Strings.tr("pl", "payer_name") }
  /// Ponów płatność
  internal static var paymentFailureButtonTitle: String { Strings.tr("pl", "payment_failure_button_title") }
  /// Płatność nieudana
  internal static var paymentFailureTitle: String { Strings.tr("pl", "payment_failure_title") }
  /// Wybierz formę płatności
  internal static var paymentMethodHeadline: String { Strings.tr("pl", "payment_method_headline") }
  /// Moje zamówienia
  internal static var paymentSuccessButtonTitle: String { Strings.tr("pl", "payment_success_button_title") }
  /// Płatność zakończona sukcesem
  internal static var paymentSuccessTitle: String { Strings.tr("pl", "payment_success_title") }
  /// Przelew
  internal static var pbl: String { Strings.tr("pl", "pbl") }
  /// Powered by
  internal static var poweredBy: String { Strings.tr("pl", "powered_by") }
  /// Jeszcze chwila. Czekamy na odpowiedź Twojego banku
  internal static var processingPaymentMessage: String { Strings.tr("pl", "processing_payment_message") }
  /// Przetwarzanie płatności
  internal static var processingPaymentTitle: String { Strings.tr("pl", "processing_payment_title") }
  /// Umieść kartę w ramce
  internal static var putCardInDetectionArea: String { Strings.tr("pl", "put_card_in_detection_area") }
  /// Zapamiętaj sklep i włącz płatność one-click
  internal static var registerBlikAliasNote: String { Strings.tr("pl", "register_blik_alias_note") }
  /// <span>Płacąc, akceptujesz <a href='%@'><b>regulamin.</b></a></span>
  internal static func regulationsNote(_ p1: String) -> String {
    return Strings.tr("pl", "regulations_note", p1)
  }
  /// Zapisz kartę, aby nie uzupełniać formularza przy następnych zakupach.
  internal static var saveCardNote: String { Strings.tr("pl", "save_card_note") }
  /// Odczyt danych odbywa się w czasie rzeczywistym. Dane karty nie są nigdzie zapisywane.
  internal static var scanningDescription: String { Strings.tr("pl", "scanning_description") }
  /// Nie udało się odczytać danych
  internal static var scanningError: String { Strings.tr("pl", "scanning_error") }
  /// Twoje dane
  internal static var setupPayerDetailsHeadline: String { Strings.tr("pl", "setup_payer_details_headline") }
  /// Coś poszło nie tak! Spróbuj ponownie.
  internal static var somethingWentWrong: String { Strings.tr("pl", "something_went_wrong") }
  /// Proszę spróbować ponownie lub wybrać inną metodę płatności
  internal static var tokenizationFailureDescription: String { Strings.tr("pl", "tokenization_failure_description") }
  /// Niestety, nie udało się dodać karty
  internal static var tokenizationFailureTitle: String { Strings.tr("pl", "tokenization_failure_title") }
  /// Możesz teraz dokonywać płatności za pomocą karty
  internal static var tokenizationSuccessDescription: String { Strings.tr("pl", "tokenization_success_description") }
  /// Karta została dodana!
  internal static var tokenizationSuccessTitle: String { Strings.tr("pl", "tokenization_success_title") }
  /// Płatność odrzucona przez użytkownika
  internal static var transactionAttemptErrorBlikDeclined: String { Strings.tr("pl", "transaction_attempt_error_blik_declined") }
  /// Ogólny błąd BLIK
  internal static var transactionAttemptErrorBlikGeneral: String { Strings.tr("pl", "transaction_attempt_error_blik_general") }
  /// Użytkownik nie posiada wystarczających środków
  internal static var transactionAttemptErrorBlikInsufficientFunds: String { Strings.tr("pl", "transaction_attempt_error_blik_insufficient_funds") }
  /// Przekroczono czas oczekiwania
  internal static var transactionAttemptErrorBlikTimeout: String { Strings.tr("pl", "transaction_attempt_error_blik_timeout") }
  /// Nieznany błąd BLIK
  internal static var transactionAttemptErrorBlikUnknown: String { Strings.tr("pl", "transaction_attempt_error_blik_unknown") }
  /// Błędy transakcji:
  internal static var transactionAttemptErrorTitle: String { Strings.tr("pl", "transaction_attempt_error_title") }
  /// Spróbuj ponownie
  internal static var tryAgain: String { Strings.tr("pl", "try_again") }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let bundlePath = Bundle.main.path(forResource: "Tpay", ofType: ".bundle") ?? Bundle(identifier: "com.tpay.sdk")?.bundlePath
    let bundle = Bundle(path: bundlePath!)!
    let format = NSLocalizedString(key, tableName: Language.current.tableName, bundle: bundle, comment: "")
    return String(format: format, locale: Language.current.locale, arguments: args)
  }
}

