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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.4/Tpay.xcframework.zip",
        checksum: "d9d13f4b4d40cd742256381492615432fcf68bed81d42420ed9494908b93cba1"
      )
    ]
)
