//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

class Label: UILabel {
    
    // MARK: - Properties
    
    private let initialFont: UIFont
    private let initialColor: UIColor
    private let initialLineHeight: LineHeight
    
    override var text: String? {
        didSet {
            set(text: text)
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            set(text: text)
        }
    }
    
    // MARK: - Initializers
    
    private init(font: UIFont, color: UIColor, lineHeight: LineHeight) {
        initialFont = font
        initialColor = color
        initialLineHeight = lineHeight
        
        super.init(frame: .zero)
        
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        
        prepareForReuse()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - API
    
    func prepareForReuse() {
        font = initialFont
        textColor = initialColor
        text = nil
    }
    
    func set(color: DesignSystem.Color) {
        textColor = color.color
    }

    func setText(asHtml htmlText: String) {
        if htmlText.hasPrefix("<span") {
            let style = "<style>span { font-family: \"\(font.fontName)\"; font-size: \(font.pointSize); }</style>"
            let styledHtmlText = style + htmlText
            guard let data = styledHtmlText.data(using: .utf16, allowLossyConversion: false) else { return }
            do {
                let text = try NSMutableAttributedString(data: data,
                                                         options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                                                         documentAttributes: nil)
                guard text.string.isNotEmpty else { return assertionFailure("\(htmlText) is not decodable as HTML") }
                attributedText = text
            } catch {
                return assertionFailure("\(htmlText) is not decodable as HTML")
            }
        } else {
            text = htmlText
        }
    }
    
    // MARK: - Private
    
    private func set(text: String?) {
        attributedText = text.map { NSAttributedString.Builder().add($0, lineHeight: initialLineHeight, textAlignment: textAlignment).build() }
    }
}

extension Label {
        
    final class H1: Label {
        
        private let fontSize: CGFloat = 18
        private let lineHeight = LineHeight.fixed(20)
        
        // MARK: - Initializers
        
        convenience init(_ color: DesignSystem.Color = DesignSystem.Colors.Primary._900) {
            self.init(medium: color)
        }
                
        init(medium color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.medium.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        init(regular color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.regular.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        required init?(coder: NSCoder) { nil }
    }
    
    final class H2: Label {
        
        private let fontSize: CGFloat = 15
        private let lineHeight = LineHeight.fixed(20)

        // MARK: - Initializers
        
        convenience init(_ color: DesignSystem.Color = DesignSystem.Colors.Primary._900) {
            self.init(medium: color)
        }
        
        init(medium color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.medium.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        init(regular color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.regular.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        required init?(coder: NSCoder) { nil }
    }
    
    final class Body: Label {
        
        private let fontSize: CGFloat = 15
        private let lineHeight = LineHeight.fixed(20)

        // MARK: - Initializers
        
        convenience init(_ color: DesignSystem.Color = DesignSystem.Colors.Primary._900) {
            self.init(regular: color)
        }
        
        init(medium color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.medium.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        init(regular color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.regular.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        required init?(coder: NSCoder) { nil }
    }
    
    final class BodySmall: Label {
        
        private let fontSize: CGFloat = 13
        private let lineHeight = LineHeight.automatic

        // MARK: - Initializers
        
        convenience init(_ color: DesignSystem.Color = DesignSystem.Colors.Primary._900) {
            self.init(regular: color)
        }
        
        init(medium color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.medium.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        init(regular color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.regular.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        required init?(coder: NSCoder) { nil }
    }
    
    final class Small: Label {
        
        private let fontSize: CGFloat = 11
        private let lineHeight = LineHeight.automatic

        // MARK: - Initializers
        
        convenience init(_ color: DesignSystem.Color = DesignSystem.Colors.Primary._900) {
            self.init(medium: color)
        }
        
        init(medium color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.medium.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        init(regular color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.regular.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        required init?(coder: NSCoder) { nil }
    }
    
    final class Micro: Label {
        
        private let fontSize: CGFloat = 10
        private let lineHeight = LineHeight.automatic

        // MARK: - Initializers
        
        convenience init(_ color: DesignSystem.Color = DesignSystem.Colors.Primary._900) {
            self.init(regular: color)
        }
        
        init(medium color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.medium.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        init(regular color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.regular.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        required init?(coder: NSCoder) { nil }
    }
    
    final class SuperMicro: Label {
        
        private let fontSize: CGFloat = 8
        private let lineHeight = LineHeight.automatic

        // MARK: - Initializers
        
        convenience init(_ color: DesignSystem.Color = DesignSystem.Colors.Primary._900) {
            self.init(regular: color)
        }
        
        init(medium color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.medium.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        init(regular color: DesignSystem.Color) {
            super.init(font: DesignSystem.Font.regular.font(size: fontSize), color: color.color, lineHeight: lineHeight)
        }
        
        required init?(coder: NSCoder) { nil }
    }
}
