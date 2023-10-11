//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

extension PayWithDigitalWalletViewController.ContentView.CollectionView {
    
    final class Delegate: NSObject {
        
        // MARK: - Events
        
        let indexPathSelected = Observable<IndexPath>()
    }
}

extension PayWithDigitalWalletViewController.ContentView.CollectionView.Delegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathSelected.on(.next(indexPath))
    }
}
