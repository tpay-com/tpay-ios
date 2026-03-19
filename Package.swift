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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.11/Tpay.xcframework.zip",
        checksum: "a76e614c22b18599ca6049f6e9c4ae78142014b15b069f0bf28acc35a1303f62"
      )
    ]
)
