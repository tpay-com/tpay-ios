//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Language {
    
    // MARK: - Properties
    
    var locale: Locale {
        switch self {
        case .pl:
            return .plPL
        case .en:
            return .enUS
        }
    }
    
    var tableName: String {
        switch self {
        case .pl:
            return "pl"
        case .en:
            return "en"
        }
    }
    
    var gdprNoteUrl: String {
        switch self {
        case .pl:
            return "https://tpay.com/user/assets/files_for_download/klauzula-informacyjna-platnik.pdf"
        case .en:
            return "https://tpay.com/user/assets/files_for_download/information-clause-payer-2022.pdf"
        }
    }
    
    var regulationsUrl: String {
        switch self {
        case .pl:
            return "https://tpay.com/user/assets/files_for_download/regulamin.pdf"
        case .en:
            return "https://tpay.com/user/assets/files_for_download/terms-and-conditions-of-payments.pdf"
        }
    }
    
    static var current: Language {
        guard let currentLanguage = ModuleContainer.instance.currentLanguage else {
            let configurationProvider: ConfigurationProvider = ModuleContainer.instance.resolver.resolve()
            return configurationProvider.preferredLanguage
        }
        return currentLanguage
    }
    
    static var supported: [Language] {
        let configurationProvider: ConfigurationProvider = ModuleContainer.instance.resolver.resolve()
        return configurationProvider.supportedLanguages
    }
}
