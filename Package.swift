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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.3/Tpay.xcframework.zip",
        checksum: "5bcfdb2fa75205dafff677e97d7a4bd97a71f99d80e2823fc1a2035db99d246d"
      )
    ]
)