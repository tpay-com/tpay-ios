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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.0.0/Tpay.xcframework.zip",
        checksum: "55e9b4aa4d99d9d7b56c3e4508791b1ba5a0ade6481466f5820ce2df8b0013ed"
      )
    ]
)