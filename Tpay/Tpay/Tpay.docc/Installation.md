# Installation

How to install the SDK.

## Integrating Tpay using SPM

```
File > Swift Packages > Add Package Dependency
Add https://github.com/tpay-com/tpay-ios.git
Select "Up to Next Major" with "1.0.0"
```

## Integrating Tpay using CocoaPods

```ruby
use_frameworks!

target :MyTarget do
  pod 'TpaySDK'
end
```

Once you have completed your Podfile, simply run `pod install`.

## Integrating Tpay manually

Simply, drag the `Tpay.xcframework` into the `Frameworks, Libraries and Embedded Content` section of your target.

## Import

To begin, make sure you have imported the `Tpay` framework into your project. You can do this by adding the following line at the top of your Swift file:

```swift
import Tpay
```
