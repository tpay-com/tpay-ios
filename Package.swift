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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.12/Tpay.xcframework.zip",
        checksum: "c7e02dab4afc3a5778f16735f29fe2eda82070e48537b7b097ed33fb48ad0145"
      )
    ]
)
