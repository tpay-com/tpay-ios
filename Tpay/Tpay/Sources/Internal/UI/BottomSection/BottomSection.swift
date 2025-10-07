//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

class BottomSection: UIView, ShadowEmitter {
    
    // MARK: - Events
    
    var actionButtonTapped: Observable<Void> { actionButton.tap }
    var secondaryActionButtonTapped: Observable<Void> { secondaryButton.tap }
    
    // MARK: - Properties
        
    private let specification: Specification
    
    private lazy var notesContainer: UIView = {
        var arrangedSubviews: [UIView] = []
        arrangedSubviews.append(regulationsNote, if: specification.withRegulationsNote)
        arrangedSubviews.append(gdprNote, if: specification.withGdprNote)
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var container: UIView = {
        var arrangedSubviews: [UIView] = [actionButton, secondaryButton, notesContainer]
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var actionButton: Button.Primary = {
        Button.Primary.Builder(button: Button.Primary())
            .set(title: specification.actionButtonTitle)
            .build() as! Button.Primary
    }()
    
    private lazy var secondaryButton: Button.Link = {
        Button.Link.Builder(button: Button.Link())
            .build() as! Button.Link
    }()
    
    private lazy var regulationsNote: TextView = {
        let textView = TextView()
        textView.setText(asHtml: Strings.regulationsNote(Language.current.regulationsUrl))
        return textView
    }()
    
    private lazy var gdprNote: TextView = {
        let textView = TextView()
        textView.setText(asHtml: Strings.gdprNote(Language.current.gdprNoteUrl))
        return textView
    }()
    
    // MARK: - Initializers
    
    init(with specification: Specification) {
        self.specification = specification
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupLayout()
        setupAppearance()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateAppearance()
    }
    
    // MARK: - ShadowEmitter
    
    func adjustAfterShading() { }
    
    func adjustAfterRemovingShade() { }
    
    // MARK: - API
    
    func set(actionButtonTitle: String) {
        actionButton.setTitle(actionButtonTitle, for: .normal)
    }
    
    func set(secondaryButtonTitle: String) {
        secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
    }
    
    func set(isProcessing: Bool) {
        let notificationName = isProcessing ? SheetViewController.UINotifications.moduleIsBusy : SheetViewController.UINotifications.moduleIsIdle
        NotificationCenter.default.post(name: notificationName, object: nil)
        actionButton.set(occupationState: isProcessing ? .busy : .idle)
    }
    
    // MARK: - Private
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        container.layout
            .add(to: self)
            .leading.equalTo(self, .leading).with(constant: 16)
            .trailing.equalTo(self, .trailing).with(constant: -16)
            .top.equalTo(self, .top).with(constant: 16)
            .bottom.equalTo(self, .bottom).with(constant: -16)
            .activate()
        
        actionButton.layout
            .leading.equalTo(container, .leading)
            .trailing.equalTo(container, .trailing)
            .activate()
        
        secondaryButton.layout
            .leading.equalTo(container, .leading)
            .trailing.equalTo(container, .trailing)
            .activate()
    }
    
    private func setupAppearance() {
        backgroundColor = .Colors.Neutral.white.color
        
        secondaryButton.titleLabel?.textAlignment = .center
        secondaryButton.isHidden = true
        secondaryButton.alpha = 0
    }
    
    private func updateAppearance() {
        if specification.withSecondaryAction {
            secondaryButton.show()
            UIView.animate(withDuration: 0.3) { [ weak self] in self?.secondaryButton.alpha = 1 }
        } else {
            secondaryButton.hide()
            secondaryButton.alpha = 0
        }
    }
}
