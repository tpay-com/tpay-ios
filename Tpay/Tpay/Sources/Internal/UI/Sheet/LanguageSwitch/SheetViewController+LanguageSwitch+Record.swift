//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController.LanguageSwitch {
    
    final class Record: UIView {
        
        // MARK: - Properties
        
        let language: Language
        private(set) var state: State = .notSelected
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: 40, height: 36)
        }
        
        private lazy var languageCodeName: Label = {
            Label.Builder(label: Label.H2())
                .set(text: language.rawValue.uppercased())
                .set(color: .Colors.Neutral._500)
                .build()
        }()
        
        // MARK: - Initializers
        
        init(language: Language) {
            self.language = language
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
            setupAppearance()
        }
        
        // MARK: - API
        
        func set(state: State) {
            self.state = state
            updateAppearance()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            languageCodeName.layout
                .add(to: self)
                .xAxis.center(with: self)
                .yAxis.center(with: self)
                .activate()
        }
        
        private func setupAppearance() {
            layer.cornerRadius = 13
            layer.masksToBounds = true
        }
        
        private func updateAppearance() {
            switch state {
            case .selected:
                backgroundColor = .Colors.Primary._100.color
                languageCodeName.set(color: .Colors.Primary._500)
            case .notSelected:
                backgroundColor = .clear
                languageCodeName.set(color: .Colors.Neutral._500)
            }
        }
    }
}

extension SheetViewController.LanguageSwitch.Record {
    
    enum State {
        
        // MARK: - Cases
        
        case selected
        case notSelected
    }
}
