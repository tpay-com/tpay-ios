//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Button.Secondary {
    
    final class AddButton: Button.Secondary {
        
        // MARK: - Initializers
        
        convenience init(text: String) {
            self.init(icon: DesignSystem.Icons.add.image, alignment: Button.Secondary.AccessoryAlignment.trailing)
            self.setTitle(text, for: .normal)
        }
    }
}
