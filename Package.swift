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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.2/Tpay.xcframework.zip",
        checksum: "1195702651a031741db9d81ffa05534fa34f52a153425b2c7e2471aadfea1d6a"
      )
    ]
)