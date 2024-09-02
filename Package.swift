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
        url: "https://github.com/tpay-com/tpay-ios/releases/download/1.3.0/Tpay.xcframework.zip",
        checksum: "b9dc6933418de59a96fea2f9050c6a204128310ddc0c1ef8f0277eaeb04a8081"
      )
    ]
)