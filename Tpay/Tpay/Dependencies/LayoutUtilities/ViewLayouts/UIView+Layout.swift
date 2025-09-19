//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

extension View {
    
    var layout: ViewLayoutConfiguration { ViewLayout(of: self) }
    
}
