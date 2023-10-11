//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController.CardView {
    
    final class TopShadowEmitter: UIView, ShadowEmitter {
        
        // MARK: - ShadowEmmiter
        
        func adjustAfterShading() { }
        func adjustAfterRemovingShade() { }
    }
}
