//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension DesignSystem.ViewController.ContentView {
    
    class Labels {
        
        lazy var view: UIView = {
            UIStackView(arrangeVertically: h1, h2, body, bodySmall, small, micro, superMicro)
        }()
        
        // MARK: - Private
        
        private lazy var h1: Label = {
            let label = Label.H1()
            label.text = "Headline 1"
            return label
        }()
        
        private lazy var h2: Label = {
            let label = Label.H2()
            label.text = "Headline 2"
            return label
        }()
        
        private lazy var body: Label = {
            let label = Label.Body()
            label.text = "Body"
            return label
        }()
        
        private lazy var bodySmall: Label = {
            let label = Label.BodySmall()
            label.text = "Body small"
            return label
        }()
        
        private lazy var small: Label = {
            let label = Label.Small()
            label.text = "Small"
            return label
        }()
        
        private lazy var micro: Label = {
            let label = Label.Micro()
            label.text = "Micro"
            return label
        }()
        
        private lazy var superMicro: Label = {
            let label = Label.SuperMicro()
            label.text = "Super micro"
            return label
        }()

    }
}
