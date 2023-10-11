//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension DesignSystem.ViewController.ContentView {
    
    class Buttons {
        
        lazy var view: UIView = {
            UIStackView(arrangeVertically: primary, primaryDisabled, primaryBusy, linkButton, checkboxesStackView, radioboxesStackView, iconButtonsStackView, secondaryButtonsStackView)
        }()
        
        // MARK: - Private
        
        private lazy var primary: Button.Primary = {
            let button = Button.Primary()
            button.setTitle("Tap me", for: .normal)
            return button
        }()
        
        private lazy var primaryDisabled: Button.Primary = {
            let button = Button.Primary()
            button.setTitle("Disabled", for: .normal)
            button.disable()
            return button
        }()
        
        private lazy var primaryBusy: Button.Primary = {
            let button = Button.Primary()
            button.setTitle("Busy", for: .normal)
            button.set(occupationState: .busy)
            return button
        }()
        
        private lazy var linkButton: Button.Link = {
            let button = Button.Link()
            button.setTitle("Anuluj", for: .normal)
            return button
        }()
        
        private lazy var checkbox: Button.Checkbox = Button.Checkbox()
        
        private lazy var selectedCheckbox: Button.Checkbox = {
            let checkbox = Button.Checkbox()
            checkbox.isSelected = true
            return checkbox
        }()
        
        private lazy var checkboxesStackView: UIStackView = {
            let view = UIView()
            let stackView = UIStackView(arrangeHorizontally: checkbox, selectedCheckbox, view)
            stackView.spacing = 8
            stackView.alignment = .center
            return stackView
        }()
        
        private lazy var radiobox: Button.Radiobox = Button.Radiobox()
        
        private lazy var selectedRadiobox: Button.Radiobox = {
            let checkbox = Button.Radiobox()
            checkbox.isSelected = true
            return checkbox
        }()
        
        private lazy var radioboxesStackView: UIStackView = {
            let view = UIView()
            let stackView = UIStackView(arrangeHorizontally: radiobox, selectedRadiobox, view)
            stackView.spacing = 8
            stackView.alignment = .center
            return stackView
        }()
        
        private lazy var closeButton: Button.Icon = Button.Icon(icon: DesignSystem.Icons.close.image)
        
        private lazy var editButton: Button.Icon = Button.Icon(icon: DesignSystem.Icons.dots.image)
        
        private lazy var iconButtonsStackView: UIStackView = {
            let view = UIView()
            let stackView = UIStackView(arrangeHorizontally: closeButton, editButton, view)
            stackView.spacing = 8
            stackView.alignment = .center
            return stackView
        }()
        
        private lazy var secondaryLeftButton: Button.Secondary = Button.Secondary.BackButton(text: "Label")
        
        private lazy var secondaryRightButton: Button.Secondary = Button.Secondary.AddButton(text: "Dodaj")
        
        private lazy var secondaryButtonsStackView: UIStackView = {
            let view = UIView()
            let stackView = UIStackView(arrangeHorizontally: secondaryLeftButton, secondaryRightButton, view)
            stackView.spacing = 8
            stackView.alignment = .center
            return stackView
        }()
    }
}
