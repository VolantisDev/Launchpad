#include "include/launchpad_dotnet/launchpad_dotnet_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "launchpad_dotnet_plugin.h"

void LaunchpadDotnetPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  launchpad_dotnet::LaunchpadDotnetPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
