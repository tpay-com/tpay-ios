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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.16/Tpay.xcframework.zip",
        checksum: "1b12d63927b8c36da5ceb07d598ab5e191c090a2827b6f1b0db43c6218fbc4ff"
      )
    ]
)
