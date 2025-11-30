# Changelog

## 0.0.2

- Added **Tamper Verification**: `getAppSignature()` and `verifyAppSignature()` to check app integrity.
- Added **iOS Background Protection**: `setIOSBackgroundProtection()` with Blur, Color, and Image modes.
- Migrated to Swift Package Manager (SPM).
- Upgraded AGP version

## 0.0.1

- Initial release of the `securx` plugin.
- Added methods for:
  - `getPlatformVersion`
  - `isDeviceSafe`
  - `isDeviceRooted`
  - `isDeveloperModeEnabled`
  - `isDebuggingModeEnabled`
  - `isEmulator`
  - `setScreenshotProtection`
  - `isDebuggerAttached`
  - `isAppCloned`
- Implemented basic Android and iOS native security checks.
