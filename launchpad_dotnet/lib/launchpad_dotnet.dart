
import 'launchpad_dotnet_platform_interface.dart';

class LaunchpadDotnet {
  Future<String?> getPlatformVersion() {
    return LaunchpadDotnetPlatform.instance.getPlatformVersion();
  }
}
