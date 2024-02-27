//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

extension PayWithRatyPekaoViewController.ContentView.CollectionView {
    
    final class DataSource: NSObject {
        
        // MARK: - Properties
        
        let viewModel: PayWithRatyPekaoViewModel
        
        // MARK: - Initializers
        
        init(viewModel: PayWithRatyPekaoViewModel) {
            self.viewModel = viewModel
        }
    }
}

extension PayWithRatyPekaoViewController.ContentView.CollectionView.DataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.paymentVariants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let paymentVariant = viewModel.paymentVariants[indexPath.row]
        let cell = collectionView.dequeue(PayWithRatyPekaoViewController.ContentView.CollectionView.Cell.self, at: indexPath)
        cell.set(paymentVariant: paymentVariant)
        return cell
    }
}
