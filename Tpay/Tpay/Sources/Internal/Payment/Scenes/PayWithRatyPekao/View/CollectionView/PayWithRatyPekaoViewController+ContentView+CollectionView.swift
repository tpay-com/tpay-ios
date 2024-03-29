//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

extension PayWithRatyPekaoViewController.ContentView {
    
    final class CollectionView: UICollectionView {
                
        // MARK: - Properties
        
        private static let collectionViewLayout: UICollectionViewLayout = {
            let layout = FlowLayout.FullWidth()
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumLineSpacing = 16
            layout.scrollDirection = .vertical
            return layout
        }()
        
        override var intrinsicContentSize: CGSize {
            collectionViewLayout.collectionViewContentSize
        }

        // MARK: - Initializers
        
        init() {
            super.init(frame: .zero, collectionViewLayout: Self.collectionViewLayout)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupAppearance()
            register(Cell.self)
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            backgroundColor = .clear
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
        }
    }
}
