//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithAmbiguousBlikAliasesViewController.ContentView.CollectionView {
    
    final class Delegate: NSObject {
        
        // MARK: - Events
        
        let indexPathSelected = Observable<IndexPath>()
    }
}

extension PayWithAmbiguousBlikAliasesViewController.ContentView.CollectionView.Delegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathSelected.on(.next(indexPath))
    }
}
