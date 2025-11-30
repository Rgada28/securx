import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:securx/securx.dart';
import 'package:securx/securx_method_channel.dart';
import 'package:securx/securx_platform_interface.dart';

class MockSecurxPlatform with MockPlatformInterfaceMixin implements SecurxPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> disableScreenshot() async {
    // Simulate successful call
    return;
  }

  @override
  Future<void> enableScreenshot() async {
    // Simulate successful call
    return;
  }

  @override
  Future<bool?> isDeviceRooted() async => false;

  @override
  Future<bool?> isDeviceSafe() async => true;

  @override
  Future<bool?> isDebuggingModeEnable() async => false;

  @override
  Future<bool?> isDeveloperModeEnabled() async => false;

  @override
  Future<bool?> isEmulator() async => false;

  @override
  Future<bool?> isVpnEnabled() async => true;

  @override
  Future<bool?> isDebuggerAttached() async => false;

  @override
  Future<bool?> isAppCloned({required String applicationID}) async => false;

  @override
  Future<String?> getAppSignature() async => 'mock_signature';

  @override
  Future<void> setIOSBackgroundProtection({
    required dynamic style,
    String? assetImage,
    String? color,
  }) async {
    return;
  }
}

void main() {
  final SecurxPlatform initialPlatform = SecurxPlatform.instance;

  test('$MethodChannelSecurx is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSecurx>());
  });

  setUp(() {
    SecurxPlatform.instance = MockSecurxPlatform();
  });

  test('getPlatformVersion', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    expect(await securxPlugin.getPlatformVersion, '42');
  });

  test('isDeviceRooted returns false', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    expect(await securxPlugin.isDeviceRooted, false);
  });

  test('isDeviceSafe returns true', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    expect(await securxPlugin.isDeviceSafe, true);
  });

  test('isDebuggingModeEnabled returns false', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    expect(await securxPlugin.isDebuggingModeEnabled, false);
  });

  test('isDeveloperModeEnabled returns false', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    expect(await securxPlugin.isDeveloperModeEnabled, false);
  });

  test('isEmulator returns false', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    expect(await securxPlugin.isEmulator, false);
  });

  test('isVpnEnabled returns true', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    expect(await securxPlugin.isVpnEnabled, true);
  });

  test('isDebuggerAttached returns false', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    expect(await securxPlugin.isDebuggerAttached, false);
  });

  test('isAppCloned returns false', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    expect(await securxPlugin.isAppCloned, false);
  });

  test('setScreenshotProtection does not throw', () async {
    Securx securxPlugin = Securx(applicationID: 'com.security.securx.securx');
    await securxPlugin.setScreenshotProtection(enabled: true);
    await securxPlugin.setScreenshotProtection(enabled: false);
    expect(true, isTrue);
  });
}
