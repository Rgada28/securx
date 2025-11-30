import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'securx_method_channel.dart';

abstract class SecurxPlatform extends PlatformInterface {
  /// Constructs a SecurxPlatform.
  SecurxPlatform() : super(token: _token);

  static final Object _token = Object();

  static SecurxPlatform _instance = MethodChannelSecurx();

  /// The default instance of [SecurxPlatform] to use.
  ///
  /// Defaults to [MethodChannelSecurx].
  static SecurxPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SecurxPlatform] when
  /// they register themselves.
  static set instance(SecurxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> isDeviceSafe() {
    throw UnimplementedError('isDeviceSafe() has not been implemented.');
  }

  Future<bool?> isDeviceRooted() {
    throw UnimplementedError('isDeviceRooted() has not been implemented.');
  }

  Future<bool?> isDebuggingModeEnable() {
    throw UnimplementedError('isDebuggingModeEnable() has not been implemented.');
  }

  Future<bool?> isDeveloperModeEnabled() {
    throw UnimplementedError('isDeveloperModeEnabled() has not been implemented.');
  }

  Future<bool?> isEmulator() {
    throw UnimplementedError('isEmulator() has not been implemented.');
  }

  Future<bool?> isVpnEnabled() {
    throw UnimplementedError('isVpnEnabled() has not been implemented.');
  }

  Future<void> disableScreenshot() {
    throw UnimplementedError('disableScreenshot() has not been implemented.');
  }

  Future<void> enableScreenshot() {
    throw UnimplementedError('enableScreenshot() has not been implemented.');
  }

  Future<bool?> isDebuggerAttached() {
    throw UnimplementedError('isDebuggerAttached() has not been implemented.');
  }

  Future<bool?> isAppCloned({required String applicationID}) {
    throw UnimplementedError('isAppCloned() has not been implemented.');
  }

  Future<String?> getAppSignature() {
    throw UnimplementedError('getAppSignature() has not been implemented.');
  }

  Future<void> setIOSBackgroundProtection({
    required dynamic
        style, // Using dynamic to avoid circular dependency or import issues if enum is in main file
    String? assetImage,
    String? color,
  }) {
    throw UnimplementedError('setIOSBackgroundProtection() has not been implemented.');
  }
}
