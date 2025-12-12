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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.6/Tpay.xcframework.zip",
        checksum: "045119fb4d3341aaed9a5355e27c67d2f5e053a9c32d4bdea14dc697f70acbf4"
      )
    ]
)
