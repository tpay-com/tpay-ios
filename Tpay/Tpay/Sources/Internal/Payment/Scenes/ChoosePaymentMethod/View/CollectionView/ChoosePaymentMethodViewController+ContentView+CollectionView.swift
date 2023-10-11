//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension ChoosePaymentMethodViewController.ContentView {
    
    final class CollectionView: UICollectionView {
                
        // MARK: - Properties
        
        private static let collectionViewLayout: UICollectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 8
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            return layout
        }()

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
            isUserInteractionEnabled = true
            alwaysBounceHorizontal = true
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
            contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
