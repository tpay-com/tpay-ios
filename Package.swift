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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/0.0.1/Tpay.xcframework.zip",
        checksum: "cd17a5f9571939d020a24226f5187a3e233484a34fe22d2d6cbecca7a06604b5"
      )
    ]
)