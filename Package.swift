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
        checksum: "2a6dfb14cfacce07a8274deb6dc729744cc8b8a399a067dc2a84e250f81aa34c"
      )
    ]
)
