# Installation

How to install the SDK.

## Integrating Tpay using SPM

```
File > Add Package Dependencies…
Enter https://github.com/tpay-com/tpay-ios.git
Set Dependency Rule to "Up to Next Major Version" from "1.0.0"
```

If you integrated the SDK with CocoaPods, follow <doc:MigratingFromCocoaPods>.

## Integrating Tpay manually

Simply, drag the `Tpay.xcframework` into the `Frameworks, Libraries and Embedded Content` section of your target.

## Import

To begin, make sure you have imported the `Tpay` framework into your project. You can do this by adding the following line at the top of your Swift file:

```swift
import Tpay
```
