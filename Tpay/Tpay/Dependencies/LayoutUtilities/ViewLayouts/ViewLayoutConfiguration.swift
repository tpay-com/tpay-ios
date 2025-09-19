//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ViewLayoutConfiguration: LayoutConfiguration {
    
    // MARK: - API
    
    @discardableResult
    func add(subviews: View...) -> ViewLayoutConfiguration
    
}
