// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

  import UIKit.UIFont
  internal typealias Font = UIFont

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum Roboto {
    internal static let medium = FontConvertible(name: "Roboto-Medium", family: "Roboto", path: "Roboto-Medium.ttf")
    internal static let regular = FontConvertible(name: "Roboto-Regular", family: "Roboto", path: "Roboto-Regular.ttf")
    internal static let all: [FontConvertible] = [medium, regular]
  }
  internal static let allCustomFonts: [FontConvertible] = [Roboto.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  internal func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    let bundlePath = Bundle.main.path(forResource: "Tpay", ofType: ".bundle") ?? Bundle(identifier: "com.tpay.sdk")?.bundlePath
    let bundle = Bundle(path: bundlePath!)!
    return bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension Font {
  convenience init!(font: FontConvertible, size: CGFloat) {
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    self.init(name: font.name, size: size)
  }
}

