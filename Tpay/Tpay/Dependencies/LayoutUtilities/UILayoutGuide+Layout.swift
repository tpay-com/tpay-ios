//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension LayoutGuide {
    
    var layout: LayoutConfiguration { LayoutGuideLayout(of: self) }
    
}
