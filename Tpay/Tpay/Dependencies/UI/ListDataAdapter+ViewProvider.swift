//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
extension ListDataAdapter {
    
    final class ViewProvider {
        
        // MARK: - Properties
        
        private let registry: ListSectionRegistry
        private var snapshotProvider: (() -> NSDiffableDataSourceSnapshot<AnySection, AnyHashable>?)?
        
        // MARK: - Getters
        
        private var snapshot: NSDiffableDataSourceSnapshot<AnySection, AnyHashable> {
            guard let snapshot = snapshotProvider?() else { preconditionFailure("Snapshot provider has to be set before calling this method") }
            return snapshot
        }
        
        // MARK: - Initialization
        
        init(registry: ListSectionRegistry) {
            self.registry = registry
        }
        
        // MARK: - Internal
        
        func set(snapshotProvider: @escaping () -> NSDiffableDataSourceSnapshot<AnySection, AnyHashable>?) {
            self.snapshotProvider = snapshotProvider
        }
        
        // MARK: - API
        
        func cell(for collectionView: UICollectionView, at indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? {
            guard let section = snapshot.sectionIdentifier(containingItem: item) else { assertionFailure("No section for item: \(item)"); return .none }
            return registry.cell(for: collectionView, at: indexPath, in: section, with: item)
        }
        
        func supplementaryView(for collectionView: UICollectionView, viewKind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
            let section = snapshot.sectionIdentifiers[indexPath.section]
            switch viewKind {
            case UICollectionView.elementKindSectionHeader: return registry.header(for: collectionView, at: indexPath, in: snapshot.sectionIdentifiers[indexPath.section], section: section)
            case UICollectionView.elementKindSectionFooter: return registry.footer(for: collectionView, at: indexPath, in: snapshot.sectionIdentifiers[indexPath.section], section: section)
            default: preconditionFailure("Unsupported supplementary element kind: \(viewKind)")
            }
        }
        
    }
    
}
