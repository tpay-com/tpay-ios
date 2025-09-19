//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol LayoutConfiguration: Layout {
    
    // MARK: - API
    
    @discardableResult
    func add(to parent: View) -> Self
    
}
