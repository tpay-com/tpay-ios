//
//  Copyright © 2022 Tpay. All rights reserved.
//

public protocol Recursive {
    
    // MARK: - Properties
    
    var frequency: Frequency { get }
    var quantity: Quantity { get }
    var expiryDate: Date { get } // dd/mm/yyyy
}
