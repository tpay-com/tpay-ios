# Migrating from CocoaPods

How to switch the SDK integration from CocoaPods to Swift Package Manager.

## Overview

New versions of the SDK are distributed only through Swift Package Manager. Migrating requires Xcode 16 or later.

## Remove the pod

Remove `pod 'Tpay-SDK'` from your Podfile and run `pod install`.

If `Tpay-SDK` was the only pod in your project:

1. Run `pod deintegrate`.
2. Delete `Podfile`, `Podfile.lock` and the `.xcworkspace` file created by CocoaPods.
3. Remove `pod install` from your build scripts and CI configuration.
4. Open your project using the `.xcodeproj` file.

## Add the package

```
File > Add Package Dependencies…
Enter https://github.com/tpay-com/tpay-ios.git
Set Dependency Rule to "Up to Next Major Version" from "1.0.0"
```
