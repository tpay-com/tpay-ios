//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class TextView: UITextView {
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        
        font = DesignSystem.Font.regular.font(size: 10)
        linkTextAttributes = [.foregroundColor: Asset.Colors.Primary._500.color,
                              .underlineColor: UIColor.clear]
        
        isScrollEnabled = false
        isEditable = false
        
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - API
    
    func setText(asHtml htmlText: String) {
        guard let font = font,
              htmlText.hasPrefix("<span") else {
                  text = htmlText
                  return
              }
        
        let style = "<style>span { font-family: \"\(font.fontName)\"; font-size: \(font.pointSize); }</style>"
        let styledHtmlText = style + htmlText
        guard let data = styledHtmlText.data(using: .utf16, allowLossyConversion: false) else { return }
        do {
            let text = try NSMutableAttributedString(data: data,
                                                     options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                                                     documentAttributes: nil)
            let range = (text.string as NSString).range(of: text.string)
            text.addAttribute(.foregroundColor, value: Asset.Colors.Neutral._500.color, range: range)
            guard text.string.isNotEmpty else { return assertionFailure("\(htmlText) is not decodable as HTML") }
            attributedText = text
        } catch {
            return assertionFailure("\(htmlText) is not decodable as HTML")
        }
    }
}
