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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.9/Tpay.xcframework.zip",
        checksum: "1ddaf420f6a0310d9715d5a892e1cde9eb17d53f3b0bb5f179236ca389e9d212"
      )
    ]
)
