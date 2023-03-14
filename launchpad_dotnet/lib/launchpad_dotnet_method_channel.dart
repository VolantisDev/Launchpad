import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'launchpad_dotnet_platform_interface.dart';

/// An implementation of [LaunchpadDotnetPlatform] that uses method channels.
class MethodChannelLaunchpadDotnet extends LaunchpadDotnetPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('launchpad_dotnet');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
