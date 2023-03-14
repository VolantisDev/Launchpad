import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'launchpad_dotnet_method_channel.dart';

abstract class LaunchpadDotnetPlatform extends PlatformInterface {
  /// Constructs a LaunchpadDotnetPlatform.
  LaunchpadDotnetPlatform() : super(token: _token);

  static final Object _token = Object();

  static LaunchpadDotnetPlatform _instance = MethodChannelLaunchpadDotnet();

  /// The default instance of [LaunchpadDotnetPlatform] to use.
  ///
  /// Defaults to [MethodChannelLaunchpadDotnet].
  static LaunchpadDotnetPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LaunchpadDotnetPlatform] when
  /// they register themselves.
  static set instance(LaunchpadDotnetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
