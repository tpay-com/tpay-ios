//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Array where Element: Sequence {
    
    func flatted() -> [Element.Element] { flatMap { $0 } }
    
}
