//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

protocol ListSectionController: ListSectionViewProvider, ListSectionLayoutProvider, ListSectionSelectionHandler {

    associatedtype SectionType: ListSection
    
}
