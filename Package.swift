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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.2.0/Tpay.xcframework.zip",
        checksum: "e8a76277ebdcd3bbd79f668832f2e0a9f43452c814ce40c4f991c8e432b00509"
      )
    ]
)