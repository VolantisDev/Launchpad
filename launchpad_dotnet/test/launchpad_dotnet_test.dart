import 'package:flutter_test/flutter_test.dart';
import 'package:launchpad_dotnet/launchpad_dotnet.dart';
import 'package:launchpad_dotnet/launchpad_dotnet_platform_interface.dart';
import 'package:launchpad_dotnet/launchpad_dotnet_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLaunchpadDotnetPlatform
    with MockPlatformInterfaceMixin
    implements LaunchpadDotnetPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LaunchpadDotnetPlatform initialPlatform = LaunchpadDotnetPlatform.instance;

  test('$MethodChannelLaunchpadDotnet is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLaunchpadDotnet>());
  });

  test('getPlatformVersion', () async {
    LaunchpadDotnet launchpadDotnetPlugin = LaunchpadDotnet();
    MockLaunchpadDotnetPlatform fakePlatform = MockLaunchpadDotnetPlatform();
    LaunchpadDotnetPlatform.instance = fakePlatform;

    expect(await launchpadDotnetPlugin.getPlatformVersion(), '42');
  });
}
