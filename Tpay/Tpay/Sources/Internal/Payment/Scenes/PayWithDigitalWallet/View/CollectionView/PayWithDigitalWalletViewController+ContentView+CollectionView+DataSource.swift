//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

extension PayWithDigitalWalletViewController.ContentView.CollectionView {
    
    final class DataSource: NSObject {
        
        // MARK: - Properties
        
        let viewModel: PayWithDigitalWalletViewModel
        
        // MARK: - Initializers
        
        init(viewModel: PayWithDigitalWalletViewModel) {
            self.viewModel = viewModel
        }
    }
}

extension PayWithDigitalWalletViewController.ContentView.CollectionView.DataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.digitalWallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let wallet = viewModel.digitalWallets[indexPath.row]
        let cell = collectionView.dequeue(PayWithDigitalWalletViewController.ContentView.CollectionView.Cell.self, at: indexPath)
        cell.set(digitalWallet: wallet)
        return cell
    }
}
