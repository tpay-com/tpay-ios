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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.1.0/Tpay.xcframework.zip",
        checksum: "13f9248e9c8a9fc3b9f85f700f38ed04675c8de04950a3776e3b8665504dca8d"
      )
    ]
)