//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

typealias PinnableContent = UIView & ShadowEmitter

protocol PinnableContentProvider: UIView {
    
    // MARK: - Properties
    
    var pinnableContent: PinnableContent { get }
    var pinnedContentPlaceholder: UIView { get }
    
    // MARK: - API
    
    func adjustAfterPinning()
}
