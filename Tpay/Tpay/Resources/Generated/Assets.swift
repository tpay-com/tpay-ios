// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal enum Neutral {
      internal static let _100 = ColorAsset(name: "Neutral/100")
      internal static let _200 = ColorAsset(name: "Neutral/200")
      internal static let _300 = ColorAsset(name: "Neutral/300")
      internal static let _500 = ColorAsset(name: "Neutral/500")
      internal static let _900 = ColorAsset(name: "Neutral/900")
      internal static let white = ColorAsset(name: "Neutral/white")
    }
    internal enum Primary {
      internal static let _100 = ColorAsset(name: "Primary/100")
      internal static let _200 = ColorAsset(name: "Primary/200")
      internal static let _500 = ColorAsset(name: "Primary/500")
      internal static let _600 = ColorAsset(name: "Primary/600")
      internal static let _700 = ColorAsset(name: "Primary/700")
      internal static let _900 = ColorAsset(name: "Primary/900")
    }
    internal enum Semantic {
      internal static let error = ColorAsset(name: "Semantic/error")
      internal static let success = ColorAsset(name: "Semantic/success")
    }
  }
  internal enum Icons {
    internal static let add = ImageAsset(name: "add")
    internal static let applePay = ImageAsset(name: "apple_pay")
    internal static let back = ImageAsset(name: "back")
    internal static let blik = ImageAsset(name: "blik")
    internal static let card = ImageAsset(name: "card")
    internal static let check = ImageAsset(name: "check")
    internal static let close = ImageAsset(name: "close")
    internal static let dots = ImageAsset(name: "dots")
    internal static let elavonLogo = ImageAsset(name: "elavonLogo")
    internal static let exclamation = ImageAsset(name: "exclamation")
    internal static let googlePay = ImageAsset(name: "google_pay")
    internal static let idCheckLogo = ImageAsset(name: "idCheckLogo")
    internal static let mastercardLogo = ImageAsset(name: "mastercardLogo")
    internal static let ocr = ImageAsset(name: "ocr")
    internal static let pciLogo = ImageAsset(name: "pciLogo")
    internal static let rightArrow = ImageAsset(name: "rightArrow")
    internal static let time = ImageAsset(name: "time")
    internal static let tpayLogoDark = ImageAsset(name: "tpayLogoDark")
    internal static let tpayLogoLight = ImageAsset(name: "tpayLogoLight")
    internal static let transfer = ImageAsset(name: "transfer")
    internal static let verifiedByVisa = ImageAsset(name: "verifiedByVisa")
    internal static let visaLogo = ImageAsset(name: "visaLogo")
    internal static let wallet = ImageAsset(name: "wallet")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundlePath = Bundle.main.path(forResource: "Tpay", ofType: ".bundle") ?? Bundle(identifier: "com.tpay.sdk")?.bundlePath
    let bundle = Bundle(path: bundlePath!)!
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundlePath = Bundle.main.path(forResource: "Tpay", ofType: ".bundle") ?? Bundle(identifier: "com.tpay.sdk")?.bundlePath
    let bundle = Bundle(path: bundlePath!)!
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundlePath = Bundle.main.path(forResource: "Tpay", ofType: ".bundle") ?? Bundle(identifier: "com.tpay.sdk")?.bundlePath
    let bundle = Bundle(path: bundlePath!)!
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundlePath = Bundle.main.path(forResource: "Tpay", ofType: ".bundle") ?? Bundle(identifier: "com.tpay.sdk")?.bundlePath
    let bundle = Bundle(path: bundlePath!)!
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

