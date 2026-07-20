//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension ChoosePaymentMethodViewController.ContentView.CollectionView {
    
    final class Delegate: NSObject {
        
        // MARK: - Events
        
        let indexPathSelected = Observable<IndexPath>()

        // MARK: - Properties

        private let viewModel: ChoosePaymentMethodViewModel

        // MARK: - Initializers

        init(viewModel: ChoosePaymentMethodViewModel) {
            self.viewModel = viewModel
        }
    }
}

extension ChoosePaymentMethodViewController.ContentView.CollectionView.Delegate: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let method = viewModel.getPaymentMethods()[indexPath.row]
        guard viewModel.isSelectable(method) else {
            viewModel.choose(method: method)
            return false
        }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathSelected.on(.next(indexPath))
    }
}
