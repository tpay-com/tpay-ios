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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.4.3/Tpay.xcframework.zip",
        checksum: "0ea2d7d6a37fc63156f8fac0432cd4b5709fee5c3e8120fc28ee34a25bb95c28"
      )
    ]
)
