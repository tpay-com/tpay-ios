//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

struct AnySection: ListSection {
    
    // MARK: - Properties
    
    let items: [AnyHashable]
    
    let sectionType: Any
    
    private let base: AnyHashable
    
    // MARK: - Initializers
    
    init<SectionType: ListSection>(wrapping section: SectionType) {
        items = section.items
        
        base = section
        sectionType = SectionType.self
    }
    
    // MARK: - API
    
    func tryUnbox<SectionType: ListSection>() -> SectionType? { base as? SectionType }
    
    // MARK: - Equatable
    
    static func == (lhs: AnySection, rhs: AnySection) -> Bool {
        lhs.base == rhs.base
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(base)
    }
    
}
