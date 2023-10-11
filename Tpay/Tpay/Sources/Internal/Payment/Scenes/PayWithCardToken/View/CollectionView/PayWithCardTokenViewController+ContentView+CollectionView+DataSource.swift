//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithCardTokenViewController.ContentView.CollectionView {
    
    final class DataSource: NSObject {
        
        // MARK: - Properties
        
        let viewModel: PayWithCardTokenViewModel
        
        // MARK: - Initializers
        
        init(viewModel: PayWithCardTokenViewModel) {
            self.viewModel = viewModel
        }
    }
}

extension PayWithCardTokenViewController.ContentView.CollectionView.DataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cardTokens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardToken = viewModel.cardTokens[indexPath.row]
        let cell = collectionView.dequeue(PayWithCardTokenViewController.ContentView.CollectionView.Cell.self, at: indexPath)
        cell.set(cardToken: cardToken)
        return cell
    }
}
