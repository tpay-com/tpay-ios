// swift-tools-version: 6.0
import PackageDescription


let package = Package(
    name: "Tpay",
    platforms: [
      .iOS(.v12)
    ],
    products: [
      .library(
        name: "Tpay",
        targets: ["Tpay"]
      )
    ],
    targets: [
      .binaryTarget(
        name: "Tpay",
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.5/Tpay.xcframework.zip",
        checksum: "243547d32a52e136b2fae50d1dda59854b40939e9be8ef96fd6d011a777e398e"
      )
    ]
)
