//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension CardBrandView {
    
    // MARK: - Initializers
    
    convenience init(brand: Domain.CardToken.Brand) {
        self.init(brandImage: brand.image)
    }
    
    // MARK: - API
    
    func set(brand: Domain.CardToken.Brand) {
        set(brandImage: brand.image)
    }
}
