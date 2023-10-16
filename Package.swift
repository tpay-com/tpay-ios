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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/0.3.1/Tpay.xcframework.zip",
        checksum: "82a28ba855b4b0f0ad0503467f0d7b54148d66c8b8c706b4773a65826bd3d6de"
      )
    ]
)