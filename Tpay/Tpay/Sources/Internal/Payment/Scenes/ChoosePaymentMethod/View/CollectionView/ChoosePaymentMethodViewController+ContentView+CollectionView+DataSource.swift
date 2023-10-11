//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension ChoosePaymentMethodViewController.ContentView.CollectionView {
    
    final class DataSource: NSObject {
        
        // MARK: - Properties
        
        private let viewModel: ChoosePaymentMethodViewModel
        
        // MARK: - Initializers:
        
        init(viewModel: ChoosePaymentMethodViewModel) {
            self.viewModel = viewModel
        }
    }
}

extension ChoosePaymentMethodViewController.ContentView.CollectionView.DataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let paymentMethods = viewModel.getPaymentMethods()
        return paymentMethods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let paymentMethods = viewModel.getPaymentMethods()
        let model = paymentMethods[indexPath.row]
        let cell = collectionView.dequeue(ChoosePaymentMethodViewController.ContentView.CollectionView.Cell.self, at: indexPath)
        cell.set(model)
        return cell
    }
}
