//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController {
    
    final class LanguageSwitch: UIView {
        
        // MARK: - Events
        
        private(set) lazy var languageSelected = _languageSelected.asObservable()

        // MARK: - Properties
        
        let initialLanguage: Language
        let supportedLanguages: [Language]
        
        private lazy var _languageSelected = Variable<Language>(initialLanguage)
                
        override var intrinsicContentSize: CGSize {
            CGSize(width: super.intrinsicContentSize.width, height: 36)
        }
        
        private var appearance: Appearance = .informative {
            didSet {
                updateAppearance()
            }
        }
        
        private lazy var records: [Record] = supportedLanguages.map { Record(language: $0) }
        
        private lazy var stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: records)
            stackView.alignment = .center
            stackView.addArrangedSubview(accessory)
            stackView.axis = .horizontal
            return stackView
        }()
        
        private let accessory = Accessory()
        
        // MARK: - Initializers
        
        init(initialLanguage: Language, supportedLanguages: [Language]) {
            self.initialLanguage = initialLanguage
            self.supportedLanguages = supportedLanguages
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
            setupAppearance()
            setupActions()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            stackView.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .top.equalTo(self, .top)
                .bottom.equalTo(self, .bottom)
                .activate()
        }
        
        private func setupAppearance() {
            backgroundColor = .Colors.Neutral.white.color
            
            layer.cornerRadius = 13
            layer.masksToBounds = true
            
            select(language: initialLanguage)
            updateAppearance()
        }
        
        private func setupActions() {
            records.forEach { record in
                record.tap.subscribe(onNext: { [weak self] in
                    self?.handleTap(on: record)
                }).add(to: disposer)
            }
            
            tap.subscribe(onNext: { [weak self] in
                self?.handleTap()
            }).add(to: disposer)
        }
        
        private func handleTap(on record: Record) {
            select(language: record.language)
        }
        
        private func handleTap() {
            records.forEach { $0.show() }
            appearance = .switching
        }
        
        private func updateAppearance() {
            switch appearance {
            case .informative:
                accessory.show()
                stackView.isUserInteractionEnabled = false
                backgroundColor = .Colors.Primary._100.color
            case .switching:
                accessory.hide()
                stackView.isUserInteractionEnabled = true
                backgroundColor = .Colors.Neutral.white.color
            }
        }
        
        private func select(language: Language) {
            guard let record = records.first(where: { $0.language == language }) else {
                return
            }
            records.filter { $0 != record }.forEach { record in
                record.set(state: .notSelected)
                record.hide()
            }
            record.set(state: .selected)
            appearance = .informative
            _languageSelected.value = record.language
        }
    }
}
