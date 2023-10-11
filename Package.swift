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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/0.0.3/Tpay.xcframework.zip",
        checksum: "225a31a71a20dd732aaad212204b23374e4959242927ea87b867f001a7bdea72"
      )
    ]
)