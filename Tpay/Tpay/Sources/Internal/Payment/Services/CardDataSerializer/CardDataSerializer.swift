//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol CardDataSerializer {
    
    // MARK: - API
    
    func serialize(card: Domain.Card) throws -> Data
}
