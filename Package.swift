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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.11/Tpay.xcframework.zip",
        checksum: "f4cadf5ff4d574991cb858a491b6746f5217fd56f52bac2d383ad79ca63c72dc"
      )
    ]
)
