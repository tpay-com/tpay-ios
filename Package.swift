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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/0.3.2/Tpay.xcframework.zip",
        checksum: "2263f9b06eba8f068ab1ba467791eb5c41d24cd19d0010e98f0855ff353f7c65"
      )
    ]
)