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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.4.0/Tpay.xcframework.zip",
        checksum: "4fef8e5f736b738c999f512198390407f3410de5d022b4331c588deb7172dbb7"
      )
    ]
)
