# Permissions

Required app permissions.

When integrating the Tpay payment module into your app, it's important to ensure that the necessary permissions are correctly set up to ensure a smooth user experience.

## Privacy - Camera Usage Description

The module allows the user to automatically fill the credit card form for secure payment processing. This feature requires you to setup the "Privacy - Camera Usage Description" in your app's `Info.plist` file.

### Integration Steps

1. Open your project's `Info.plist` file.

2. Add the key-value pair for the "Privacy - Camera Usage Description" permission, explaining the purpose of camera access. Clearly state that the camera is used to facilitate the automatic filling of the credit card form for secure payment processing.

Example:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to automatically fill the credit card form for secure payment processing.</string>
```
