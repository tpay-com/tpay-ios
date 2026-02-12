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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.10/Tpay.xcframework.zip",
        checksum: "7ed6967b606e7d31ff713d8a122c7e8bc6d825fd0363664ae32475c927d08cbd"
      )
    ]
)
