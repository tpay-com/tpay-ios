//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

enum DesignSystem { }

// MARK: - Type aliases

extension DesignSystem {
    
    typealias Color = ColorAsset
    typealias Colors = Asset.Colors
    typealias Icons = Asset.Icons
    
    typealias Font = FontFamily.Roboto
}

extension ColorAsset {
    
    typealias Colors = Asset.Colors
}

extension UIColor {
    
    typealias Colors = Asset.Colors
}
