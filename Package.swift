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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.2/Tpay.xcframework.zip",
        checksum: "f2367a1925f0308ea61367fefa9aa2c117f5e5c5340977eff77577f62c1adb8c"
      )
    ]
)