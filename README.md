# Tpay

[![Min iOS](https://img.shields.io/badge/ios-12.0-informational.svg)](https://shields.io/) [![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://shields.io/) 

[Full documentation](https://tpay-com.github.io/tpay-ios/documentation/tpay/)

## Installation

How to install the SDK.

### Integrating Tpay using SPM

```
File > Swift Packages > Add Package Dependency
Add https://github.com/tpay-com/tpay-ios.git
Select "Up to Next Major" with "1.0.0"
```

### Integrating Tpay using CocoaPods

```ruby
use_frameworks!

target :MyTarget do
  pod 'Tpay-SDK'
end
```

Once you have completed your Podfile, simply run `pod install`.

### Integrating Tpay manually

Simply, drag the `Tpay.xcframework` into the `Frameworks, Libraries and Embedded Content` section of your target.

### Import

To begin, make sure you have imported the `Tpay` framework into your project. You can do this by adding the following line at the top of your Swift file:

```swift
import Tpay
```

## License

This library is released under the [MIT License](https://opensource.org/license/mit/).