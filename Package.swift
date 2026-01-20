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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.8/Tpay.xcframework.zip",
        checksum: "13ae5bcaa1f47d4174d61a6e01f69aff21a1f89f65f078ffa052004a1565e629"
      )
    ]
)
