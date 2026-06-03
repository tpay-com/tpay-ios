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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.19/Tpay.xcframework.zip",
        checksum: "a7274e263cc4bdbd2b3b4cf9cad41cdbe1942477f4a8dafbe851185d6fb90805"
      )
    ]
)
