//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

extension PayWithRatyPekaoViewController.ContentView.CollectionView {
    
    final class Delegate: NSObject {
        
        // MARK: - Events
        
        let indexPathSelected = Observable<IndexPath>()
    }
}

extension PayWithRatyPekaoViewController.ContentView.CollectionView.Delegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathSelected.on(.next(indexPath))
    }
}
