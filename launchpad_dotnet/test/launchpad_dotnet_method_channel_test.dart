import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchpad_dotnet/launchpad_dotnet_method_channel.dart';

void main() {
  MethodChannelLaunchpadDotnet platform = MethodChannelLaunchpadDotnet();
  const MethodChannel channel = MethodChannel('launchpad_dotnet');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
