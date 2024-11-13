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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.1/Tpay.xcframework.zip",
        checksum: "1b52fd17e98843c64aa12a91e42d5b8dfdfdcd249cae566804517754c7e91429"
      )
    ]
)