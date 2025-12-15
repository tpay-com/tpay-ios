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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.7/Tpay.xcframework.zip",
        checksum: "e62178128a61493e55019b82aaa8bba77fe5c49365ef9baa1fbe4c7bcf660823"
      )
    ]
)
