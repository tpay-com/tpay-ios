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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.4.1/Tpay.xcframework.zip",
        checksum: "7213305aad4b221c9128a03d42c661fcbcf23ed2cef273ed6e1eb620fc219a9c"
      )
    ]
)
