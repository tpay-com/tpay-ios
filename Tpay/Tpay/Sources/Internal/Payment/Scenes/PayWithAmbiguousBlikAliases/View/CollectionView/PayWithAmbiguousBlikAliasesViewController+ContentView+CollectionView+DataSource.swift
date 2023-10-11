//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithAmbiguousBlikAliasesViewController.ContentView.CollectionView {
    
    final class DataSource: NSObject {
        
        // MARK: - Properties
        
        let viewModel: PayWithAmbiguousBlikAliasesViewModel
        
        // MARK: - Initializers
        
        init(viewModel: PayWithAmbiguousBlikAliasesViewModel) {
            self.viewModel = viewModel
        }
    }
}

extension PayWithAmbiguousBlikAliasesViewController.ContentView.CollectionView.DataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.blikAliases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let blikAlias = viewModel.blikAliases[indexPath.row]
        let cell = collectionView.dequeue(PayWithAmbiguousBlikAliasesViewController.ContentView.CollectionView.Cell.self, at: indexPath)
        cell.set(blikAlias: blikAlias)
        return cell
    }
}
