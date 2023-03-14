import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_service_providers.g.dart';

class WebServiceProvider {
  WebServiceProvider({
    required this.key,
    required this.name,
    this.url,
    this.icon,
    this.color,
    this.accentColor,
    this.logoPath,
    this.description,
  });

  final String key;
  final String name;
  final String? url;
  final String? icon;
  final String? color;
  final String? accentColor;
  final String? logoPath;
  final String? description;
}

@Riverpod(keepAlive: true)
Future<Map<String, WebServiceProvider>> webServiceProviders(
    WebServiceProvidersRef ref) async {
  return {
    "launchpad.games": WebServiceProvider(
      key: "launchpad.games",
      name: "Launchpad.games",
      description:
          "The official Launchpad website, which offers cloud syncing and full API access.",
    ),
  };
}
