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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.13/Tpay.xcframework.zip",
        checksum: "db211d30cf42ca445ce990b12e6be9a2fd3fb7fa9d9d738e27df9bc0c3f378d5"
      )
    ]
)
