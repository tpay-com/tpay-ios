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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.5.0/Tpay.xcframework.zip",
        checksum: "3292806751dd3e96bc5f0a097a3f383069e04366fa5e3104f8a12977042657e8"
      )
    ]
)
