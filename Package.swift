// swift-tools-version:5.3
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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/0.0.4/Tpay.xcframework.zip",
        checksum: "70d20dded085e0e0fdd2fcbc4190da3ea20792bb4874fdacbb5d6c19e46e8bdb"
      )
    ]
)