//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayByLinkViewController.ContentView.CollectionView {
    
    final class DataSource: NSObject {
        
        // MARK: - Properties
        
        let viewModel: PayByLinkViewModel
        
        // MARK: - Initializers
        
        init(viewModel: PayByLinkViewModel) {
            self.viewModel = viewModel
        }
    }
}

extension PayByLinkViewController.ContentView.CollectionView.DataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.banks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bank = viewModel.banks[indexPath.row]
        let cell = collectionView.dequeue(PayByLinkViewController.ContentView.CollectionView.Cell.self, at: indexPath)
        cell.set(bank: bank)
        return cell
    }
    
}
