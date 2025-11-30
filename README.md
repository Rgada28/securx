
# Securx - A Security Analysis Package

[![pub package](https://img.shields.io/pub/v/securx.svg)](https://pub.dev/packages/securx)
[![Maintenance](https://img.shields.io/maintenance/yes/2025)](https://pub.dev/packages/securx/score)
[![points](https://img.shields.io/pub/points/securx)](https://pub.dev/packages/securx/score)


A robust mobile security package designed to enhance application resilience against various threats. This package includes features for device integrity checks, secure communication, mobile privacy, and fraud prevention.

## Features

### Device Integrity
- **Root Detection**: Detects rooted devices to prevent unauthorized modifications.
    - **Severity**: High
    - **Benefits**: Prevents tampering and enhances app security.

- **Emulator Detection**: Identifies if the app runs in an emulator, a common tool for reverse engineering.
    - **Severity**: High
    - **Benefits**: Reduces the risk of reverse engineering and debugging attacks.

- **Debugger Detection**: Identifies debuggers attached to the app.
    - **Severity**: High
    - **Benefits**: Increases resistance to runtime inspection and protects sensitive data.

- **Malicious Root App Detection**: Flags root management apps that can compromise security.
    - **Severity**: Medium
    - **Benefits**: Safeguards user data from root-level threats.

### OS Integrity
- **ADB Wireless/USB Debugging Detection**: Flags if ADB debugging is enabled.
    - **Severity**: Low
    - **Benefits**: Protects against unauthorized debugging and data exposure.

- **Developer Mode Detection**: Identifies if developer mode is active.
    - **Severity**: Low
    - **Benefits**: Minimizes attack surface by disabling additional tools for attackers.

### Secure Communication
- **VPN Detection**: Checks if the app is accessed over a VPN.
    - **Severity**: Low
    - **Benefits**: Provides network security insights.

### Mobile Privacy
- **Screen Capturing Prevention**: Restricts unauthorized screenshots or recordings.
    - **Severity**: Medium
    - **Benefits**: Secures sensitive visual data.



- **Screen Sharing Prevention**: Restricts unauthorized screen sharing.
    - **Severity**: Medium
    - **Benefits**: Protects sensitive visual information.

### Mobile Fraud
- **App Cloning/Second Space Detection**: Identifies cloned apps or dual instances to prevent fraud.
    - **Severity**: Medium
    - **Benefits**: Protects against impersonation and unauthorized access.

## Installation

To integrate this package into your project:

```bash
flutter pub add securx
```

## Usage

### Initialization
Initialize the plugin with your application ID. You can also set initial protection states.

```dart
import 'package:securx/securx.dart';

final _securxPlugin = Securx(
  applicationID: "com.example.yourapp",
  initialScreenshotProtection: true, // Block screenshots on startup
  // initialClipboardProtection: true,  // Block copy/paste on startup
);
```

### Device Integrity Checks
Check if the device is safe to run your application.

```dart
// Comprehensive check (Root, Emulator, Debugger, etc.)
bool? isSafe = await _securxPlugin.isDeviceSafe;

if (!isSafe) {
  // Handle unsafe device
}

// Individual checks
bool? isRooted = await _securxPlugin.isDeviceRooted;
bool? isEmulator = await _securxPlugin.isEmulator;
bool? isDebuggerAttached = await _securxPlugin.isDebuggerAttached;
```

### App Integrity (Tamper Verification)
Verify that your app hasn't been modified or resigned by an attacker.

```dart
// 1. Get the signature hash (SHA-256) of the current app
String? currentSignature = await _securxPlugin.getAppSignature();
print("App Signature: $currentSignature");

// 2. Verify against your known good hash (store this securely!)
bool isValid = await _securxPlugin.verifyAppSignature(
  expectedHash: "YOUR_EXPECTED_SHA256_HASH_HERE",
);

if (!isValid) {
  // App has been tampered with!
}
```

### Screen Protection
Prevent sensitive data from being captured via screenshots or screen recording.

```dart
// Enable protection (prevent screenshots)
await _securxPlugin.setScreenshotProtection(enabled: true);

// Disable protection (allow screenshots)
await _securxPlugin.setScreenshotProtection(enabled: false);
```

### iOS Background Protection
Customize how your app appears in the iOS App Switcher to hide sensitive content.

```dart
// Blur the screen
await _securxPlugin.setIOSBackgroundProtection(
  style: BackgroundProtectionStyle.blur,
);

// Show a solid color (e.g., Red)
await _securxPlugin.setIOSBackgroundProtection(
  style: BackgroundProtectionStyle.color,
  color: "#FF0000",
);

// Show a custom image from Assets
await _securxPlugin.setIOSBackgroundProtection(
  style: BackgroundProtectionStyle.image,
  assetImage: "launch_image", // Name of the image in your asset bundle
);

// Disable background protection
await _securxPlugin.setIOSBackgroundProtection(
  style: BackgroundProtectionStyle.none,
);
```



### Other Security Checks

```dart
// Check for VPN
bool? isVpnActive = await _securxPlugin.isVpnEnabled;

// Check for App Cloning (Android only)
bool? isCloned = await _securxPlugin.isAppCloned;

// Check Developer Mode / Debugging (Android)
bool? isDevMode = await _securxPlugin.isDeveloperModeEnabled;
bool? isDebugging = await _securxPlugin.isDebuggingModeEnabled;
```

## Compatibility

| Feature                             | Android | iOS  |
| ----------------------------------- | :-----: | :--: |
| Root / Jailbreak Detection          |   ✅    |   ✅  |
| Emulator Detection                  |   ✅    |   ✅  |
| Debugger Detection                  |   ✅    |   ✅  |
| Tamper Verification (Signature)     |   ✅    |   ✅  |
| Malicious Root App Detection        |   ✅    |   ❌  |
| ADB Debugging Detection             |   ✅    |   ❌  |
| Developer Mode Detection            |   ✅    |   ❌  |
| VPN Detection                       |   ✅    |   ✅  |
| Screen Capturing Prevention         |   ✅    |   ✅  |
| iOS Background Protection           |   ❌    |   ✅  |
| Screen Share Prevention             |   ✅    |   ✅  |
| App Cloning/Second Space Detection  |   ✅    |   ❌  |

