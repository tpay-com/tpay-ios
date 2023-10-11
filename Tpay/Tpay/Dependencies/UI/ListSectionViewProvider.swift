//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

protocol ListSectionViewProvider {
    
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell?
    func header(for collectionView: UICollectionView, at indexPath: IndexPath, section: AnySection) -> UICollectionReusableView?
    func footer(for collectionView: UICollectionView, at indexPath: IndexPath, section: AnySection) -> UICollectionReusableView?
    
}
