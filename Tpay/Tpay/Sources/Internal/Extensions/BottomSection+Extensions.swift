//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension BottomSection {
    
    func set(amount: Double) {
        let priceToStringConverter = DefaultPriceToStringConverter(locale: Language.current.locale)
        let price = Domain.Price(amount: amount)
        let priceString = priceToStringConverter.string(from: price)
        let title = Strings.imPaying(priceString)
        set(actionButtonTitle: title)
    }
}
