//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    // MARK: - Cells
    
    func register<CellType: UICollectionViewCell>(_ type: CellType.Type) {
        register(type, forCellWithReuseIdentifier: type.description())
    }
    
    func register<CellType: UICollectionViewCell>(_ type: CellType.Type, for state: String) {
        register(type, forCellWithReuseIdentifier: type.description() + "|" + state)
    }
    
    func dequeue<CellType: UICollectionViewCell>(_ type: CellType.Type, at indexPath: IndexPath) -> CellType {
        let reusableCell = dequeueReusableCell(withReuseIdentifier: CellType.description(), for: indexPath)
        guard let cell = reusableCell as? CellType else {
            preconditionFailure("Type mismatch: Cannot cast \(reusableCell) to \(CellType.self)")
        }
        return cell
    }
    
    func dequeue<CellType: UICollectionViewCell>(_ type: CellType.Type, for state: String, at indexPath: IndexPath) -> CellType {
        let reusableCell = dequeueReusableCell(withReuseIdentifier: CellType.description() + "|" + state, for: indexPath)
        guard let cell = reusableCell as? CellType else {
            preconditionFailure("Type mismatch: Cannot cast \(reusableCell) to \(CellType.self)")
        }
        return cell
    }
    
    // MARK: - Headers
    
    func register<HeaderType: UICollectionReusableView>(header: HeaderType.Type) {
        register(header,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: header.description())
    }
    
    func register<FooterType: UICollectionReusableView>(footer: FooterType.Type) {
        register(footer,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: footer.description())
    }
    
    func dequeue<HeaderType: UICollectionReusableView>(header: HeaderType.Type, for indexPath: IndexPath) -> HeaderType {
        let reusableHeader = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                              withReuseIdentifier: header.description(),
                                                              for: indexPath)
        guard let header = reusableHeader as? HeaderType else {
            preconditionFailure("Type mismatch: Cannot cast \(reusableHeader) to \(HeaderType.self)")
        }
        return header
    }
    
    func dequeue<FooterType: UICollectionReusableView>(footer: FooterType.Type, for indexPath: IndexPath) -> FooterType {
        let reusableFooter = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                              withReuseIdentifier: footer.description(),
                                                              for: indexPath)
        guard let footer = reusableFooter as? FooterType else {
            preconditionFailure("Type mismatch: Cannot cast \(reusableFooter) to \(FooterType.self)")
        }
        return footer
    }
    
}
