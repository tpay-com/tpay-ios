//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
final class ListDataAdapter: UICollectionViewDiffableDataSource<AnySection, AnyHashable> {

    // MARK: - Properties

    private let registry: ListSectionRegistry
    private let provider: ViewProvider

    private var wereSectionsSet = false

    // MARK: - Initialization

    init(collectionView: UICollectionView, registry: ListSectionRegistry) {
        self.registry = registry
        provider = ViewProvider(registry: registry)

        super.init(collectionView: collectionView, cellProvider: provider.cell(for:at:item:))

        collectionView.delegate = self

        provider.set { [weak self] in
            guard let self = self else { preconditionFailure("Self missing") }
            return self.snapshot()
        }

        supplementaryViewProvider = provider.supplementaryView(for:viewKind:at:)
    }

    // MARK: - Public

    func set(_ sections: [AnySection]) {
        var snapshot = NSDiffableDataSourceSnapshot<AnySection, AnyHashable>()
        snapshot.appendSections(sections)
        sections.forEach { section in snapshot.appendItems(section.items, toSection: section) }
        apply(snapshot, animatingDifferences: wereSectionsSet)
        wereSectionsSet = true
    }

    func section(at index: Int) -> AnySection {
        snapshot().sectionIdentifiers[index]
    }

}

@available(iOS 13.0, *)
extension ListDataAdapter: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection {
            for path in collectionView.indexPathsForSelectedItems ?? [] where path != indexPath {
                collectionView.deselectItem(at: path, animated: true)
            }
        }
        let section = snapshot().sectionIdentifiers[indexPath.section]
        let item = snapshot().itemIdentifiers(inSection: section)[indexPath.item]

        registry.select(item: item, in: section)
    }

}
