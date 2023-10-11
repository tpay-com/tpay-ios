//
//  Copyright © 2022 Tpay. All rights reserved.
//

// TODO: To be removed after https://jira.rndlab.online/browse/TPAY-35 is completed.

import UIKit

extension DesignSystem {
    
    final class ViewController: UIViewController {
        
        // MARK: - Properties
        
        private let contentView = ContentView()
        
        // MARK: - Lifecycle
        
        override func loadView() {
            view = contentView
        }
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            endEditingOnTap()
        }
    }
}

extension DesignSystem.ViewController {
    
    final class ContentView: UIScrollView {
        
        // MARK: - Properties
        
        private lazy var stackView: UIStackView = {
            UIStackView(arrangeVertically: textInputs, labels, loaders, buttons, lines)
        }()
        
        private lazy var labels: UIView = { Labels().view }()
        private lazy var buttons: UIView = { Buttons().view }()
        private lazy var lines: UIView = {
            let generated = Generator(numberOfLines: 100).generate()
            let stackView = UIStackView(arrangedSubviews: generated)
            stackView.axis = .vertical
            return stackView
        }()
        private lazy var textInputs: UIView = { TextInputs().view }()
        private lazy var loaders: UIView = { Loaders().view }()
            
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
            setupAppearance()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            stackView.layout
                .add(to: self)
                .leading.equalTo(safeAreaLayoutGuide, .leading).with(constant: 16)
                .trailing.equalTo(safeAreaLayoutGuide, .trailing).with(constant: -16)
                .top.equalTo(self, .top).with(constant: 16)
                .bottom.equalTo(self, .bottom).with(constant: -16)
                .activate()
        }
        
        private func setupAppearance() {
            backgroundColor = .white
        }
    }
}
