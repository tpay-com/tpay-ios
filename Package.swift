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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.18/Tpay.xcframework.zip",
        checksum: "30a164ec80ecfcd292385e8c75a4fb635bc90e560e2661a59a6d24ddb5ab6f9c"
      )
    ]
)
