//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

protocol ListSectionLayoutProvider {
    
    @available(iOS 13.0, *)
    func layout(in environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    
}
