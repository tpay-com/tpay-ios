//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension DesignSystem.ViewController.ContentView {
    
    class Loaders {
        
        lazy var view: UIView = {
            let stackView = UIStackView(arrangeHorizontally: loader, ocrLoader, UIView())
            stackView.alignment = .center
            return stackView
        }()
        
        // MARK: - Private
        
        private lazy var loader = Loader(style: .default, color: .Colors.Primary._600.color)
        private lazy var ocrLoader = ComplexBackgroundLoader()
    }
}
