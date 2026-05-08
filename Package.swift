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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.17/Tpay.xcframework.zip",
        checksum: "9007fe862556f14341c9689659ddf3df918c243881ec75321db21e951b3dd8cf"
      )
    ]
)
