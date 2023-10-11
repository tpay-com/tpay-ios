//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
final class ListSectionRegistry {

    // MARK: - Properties

    private var registry: [String: SectionBox] = [:]

    // MARK: - Initializers

    init() {}

    // MARK: - Public

    func register<ViewSection: ListSectionController>(_ viewSection: ViewSection) {
        let typeIdentifier = String(reflecting: ViewSection.SectionType.self)
        registry[typeIdentifier] = SectionBox(section: viewSection)
    }

    func layout(for section: AnySection, in environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        sectionLayoutProvider(for: section).layout(in: environment)
    }

    // MARK: - Internal

    func cell(for collectionView: UICollectionView, at indexPath: IndexPath, in model: AnySection, with item: AnyHashable) -> UICollectionViewCell? {
        sectionViewProvider(for: model).cell(for: collectionView, at: indexPath, item: item)
    }

    func header(for collectionView: UICollectionView, at indexPath: IndexPath, in model: AnySection, section: AnySection) -> UICollectionReusableView? {
        sectionViewProvider(for: model).header(for: collectionView, at: indexPath, section: section)
    }

    func footer(for collectionView: UICollectionView, at indexPath: IndexPath, in model: AnySection, section: AnySection) -> UICollectionReusableView? {
        sectionViewProvider(for: model).footer(for: collectionView, at: indexPath, section: section)
    }

    func select(item: AnyHashable, in section: AnySection) {
        sectionSelectionHandler(for: section).select(item: item)
    }

    // MARK: - Private

    private func sectionViewProvider(for section: AnySection) -> ListSectionViewProvider {
        let typeIdentifier = String(reflecting: section.sectionType)
        guard let section = registry[typeIdentifier]?.viewSection else {
            preconditionFailure("Register \"ListSectionController\" type for \(typeIdentifier)")
        }
        return section
    }

    private func sectionLayoutProvider(for section: AnySection) -> ListSectionLayoutProvider {
        let typeIdentifier = String(reflecting: section.sectionType)
        guard let section = registry[typeIdentifier]?.viewSection else {
            preconditionFailure("Register \"ListSectionController\" type for \(typeIdentifier)")
        }
        return section
    }
    
    private func sectionSelectionHandler(for section: AnySection) -> ListSectionSelectionHandler {
        let typeIdentifier = String(reflecting: section.sectionType)
        guard let section = registry[typeIdentifier]?.viewSection else {
            preconditionFailure("Register \"ListSectionController\" type for \(typeIdentifier)")
        }
        return section
    }

}

@available(iOS 13.0, *)
extension ListSectionRegistry {

    private struct SectionBox {

        // MARK: - Properties

        let viewSection: ListSectionViewProvider & ListSectionLayoutProvider & ListSectionSelectionHandler

        // MARK: - Initializers

        init<ViewSection: ListSectionController>(section: ViewSection) {
            viewSection = section
        }

    }

}
