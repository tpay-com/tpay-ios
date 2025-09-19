//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

extension NSAttributedString {
    
    // MARK: - Builder
    
    final class Builder {
        
        // MARK: - Properties
        
        private let mutableAttributedString: NSMutableAttributedString
        
        // MARK: - Initialization
        
        /// Will create a `Builder` with an empty attributedString
        convenience init() {
            self.init(attributedString: NSAttributedString())
        }
        
        /// Will create a new `Builder` with the given `NSAttributedString`
        ///
        /// - parameter attributedString: the baseline attributedString
        init(attributedString: NSAttributedString) {
            mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        }
        
        // MARK: - API
        
        /// Builds string from previously added substrings
        ///
        /// - Returns: builded `NSAttributedString`
        func build() -> NSAttributedString { NSAttributedString(attributedString: mutableAttributedString) }
        
        /// Appends given text to the string that is under construction
        ///
        /// - Parameters:
        ///   - text:       Text to append to string under construction.
        ///   - attributes: Attributes that will be set to the text
        ///
        /// - Returns: The `Builder` instance on which this function was called
        @discardableResult
        func add(_ text: String, with attributes: TextAttribute...) -> Self {
            let attributes = attributesDictionary(for: attributes)
            let string = NSAttributedString(string: text, attributes: attributes)
            mutableAttributedString.append(string)
            return self
        }
        
        // MARK: - Methods
        
        private func attributesDictionary(for attributes: [TextAttribute]) -> [NSAttributedString.Key: Any] {
            var dictionary = [NSAttributedString.Key: Any]()
            let paragraphStyle = NSMutableParagraphStyle()
            attributes.forEach { attribute in
                switch attribute {
                case let .baselineOffset(offset): dictionary[.baselineOffset] = offset
                case let .font(font): dictionary[.font] = font
                case let .kerning(value): dictionary[.kern] = value
                case let .textColor(color): dictionary[.foregroundColor] = color
                case let .underline(style): dictionary[.underlineStyle] = style.rawValue
                case let .minimumLineHeight(height): paragraphStyle.minimumLineHeight = height
                case let .textAlignment(alignment): paragraphStyle.alignment = alignment
                }
            }
            dictionary[.paragraphStyle] = paragraphStyle
            return dictionary
        }
        
    }
    
}
