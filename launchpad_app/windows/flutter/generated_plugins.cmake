#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  catcher
  desktop_drop
  desktop_webview_auth
  file_selector_windows
  flutter_acrylic
  hotkey_manager
  isar_flutter_libs
  local_auth_windows
  local_notifier
  native_context_menu
  network_info_plus
  protocol_handler
  screen_retriever
  system_theme
  tray_manager
  url_launcher_windows
  window_manager
  windows_single_instance
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/windows plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)
