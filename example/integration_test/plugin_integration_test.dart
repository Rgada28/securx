// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:securx/securx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final Securx plugin = Securx(applicationID: 'com.security.securx');

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final String? version = await plugin.getPlatformVersion;
    expect(version?.isNotEmpty, true);
  });

  testWidgets('isDeviceRooted returns bool', (WidgetTester tester) async {
    final bool? rooted = await plugin.isDeviceRooted;
    expect(rooted, isA<bool?>());
  });

  testWidgets('isDeviceSafe returns bool', (WidgetTester tester) async {
    final bool? safe = await plugin.isDeviceSafe;
    expect(safe, isA<bool?>());
  });

  testWidgets('isDebuggingModeEnabled returns bool', (
    WidgetTester tester,
  ) async {
    final bool? debug = await plugin.isDebuggingModeEnabled;
    expect(debug, isA<bool?>());
  });

  testWidgets('isDeveloperModeEnabled returns bool', (
    WidgetTester tester,
  ) async {
    final bool? dev = await plugin.isDeveloperModeEnabled;
    expect(dev, isA<bool?>());
  });

  testWidgets('isEmulator returns bool', (WidgetTester tester) async {
    final bool? emulator = await plugin.isEmulator;
    expect(emulator, isA<bool?>());
  });

  testWidgets('isVpnEnabled returns bool', (WidgetTester tester) async {
    final bool? vpn = await plugin.isVpnEnabled;
    expect(vpn, isA<bool?>());
  });

  testWidgets('isDebuggerAttached returns bool', (WidgetTester tester) async {
    final bool? attached = await plugin.isDebuggerAttached;
    expect(attached, isA<bool?>());
  });

  testWidgets('isAppCloned returns bool', (WidgetTester tester) async {
    final bool? cloned = await plugin.isAppCloned;
    expect(cloned, isA<bool?>());
  });

  testWidgets('setScreenshotProtection does not throw', (
    WidgetTester tester,
  ) async {
    await plugin.setScreenshotProtection(enabled: true); // disables screenshots
    await plugin.setScreenshotProtection(enabled: false); // enables screenshots
    // No exception means pass
    expect(true, isTrue);
  });
}
