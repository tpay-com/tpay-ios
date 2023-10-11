//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayByLinkViewController.ContentView {
    
    final class FlowLayout: UICollectionViewFlowLayout {
        
        // MARK: - Properties
        
        private let cellsPerRow = 2
        
        // MARK: - Overrides
        
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
            guard let collectionView = collectionView else { return layoutAttributes }
            
            let marginsAndInsets = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            layoutAttributes.bounds.size.width = ((collectionView.bounds.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            
            return layoutAttributes
        }
        
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map { $0.copy() } as? [UICollectionViewLayoutAttributes]
            layoutAttributesObjects?.forEach { layoutAttributes in
                if layoutAttributes.representedElementCategory == .cell {
                    if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                        layoutAttributes.frame = newFrame
                    }
                }
            }
            return layoutAttributesObjects
        }
    }
}
