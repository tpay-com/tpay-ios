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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/0.4.0/Tpay.xcframework.zip",
        checksum: "276a65a573b8cde32d05dc67971608589f1afb3b220d1e81f845c4f9fb4d4678"
      )
    ]
)