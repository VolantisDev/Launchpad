#ifndef FLUTTER_PLUGIN_LAUNCHPAD_DOTNET_PLUGIN_H_
#define FLUTTER_PLUGIN_LAUNCHPAD_DOTNET_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace launchpad_dotnet {

class LaunchpadDotnetPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  LaunchpadDotnetPlugin();

  virtual ~LaunchpadDotnetPlugin();

  // Disallow copy and assign.
  LaunchpadDotnetPlugin(const LaunchpadDotnetPlugin&) = delete;
  LaunchpadDotnetPlugin& operator=(const LaunchpadDotnetPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace launchpad_dotnet

#endif  // FLUTTER_PLUGIN_LAUNCHPAD_DOTNET_PLUGIN_H_
