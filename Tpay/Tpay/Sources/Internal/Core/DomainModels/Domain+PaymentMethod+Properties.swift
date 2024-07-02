//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

extension Domain.PaymentMethod {
    
    // MARK: - Properties
    
    var title: String? {
        switch self {
        case .blik: return Strings.blik
        case .pbl: return Strings.pbl
        case .card: return Strings.card
        case .digitalWallet: return Strings.digitalWallets
        case .installmentPayments: return Strings.ratyPekao
        case .payPo: return Strings.payPo
        case .unknown: return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .blik: return DesignSystem.Icons.blik.image
        case .pbl: return DesignSystem.Icons.transfer.image
        case .card: return DesignSystem.Icons.card.image
        case .digitalWallet: return DesignSystem.Icons.wallet.image
        case .installmentPayments: return DesignSystem.Icons.ratyPekaoLogo.image
        case .payPo: return DesignSystem.Icons.payPoLogo.image
        case .unknown: return nil
        }
    }
}
