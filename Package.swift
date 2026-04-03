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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.14/Tpay.xcframework.zip",
        checksum: "f22d4504d9ef4985af45706d384cb61150aa340ed2045b56cee51ae7b130fbc8"
      )
    ]
)
