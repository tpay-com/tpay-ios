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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.4.2/Tpay.xcframework.zip",
        checksum: "b9dce729eabc39b5ff9939cdf9b222e02b48425fa26198f8cecef606420215c0"
      )
    ]
)
