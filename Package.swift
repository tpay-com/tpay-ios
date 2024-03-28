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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.0.0/Tpay.xcframework.zip",
        checksum: "749e7b6033c00b15d7c8e81fdff5eeb427886899c5f56d660ea568515193475c"
      )
    ]
)