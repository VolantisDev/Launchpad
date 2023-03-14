// An Adapter takes data from a web service and converts it to a domain object.

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_service_adapter_types.g.dart';

class WebServiceAdapterType {
  const WebServiceAdapterType({
    required this.key,
    required this.name,
    this.description = '',
  });

  final String key;
  final String name;
  final String description;
}

@Riverpod(keepAlive: true)
Future<Map<String, WebServiceAdapterType>> webServiceAdapterTypes(
    WebServiceAdapterTypesRef ref) async {
  return {
    "game": const WebServiceAdapterType(
      key: "game",
      name: "Game",
      description: "Data representing a game.",
    ),
    "game_asset": const WebServiceAdapterType(
      key: "game_asset",
      name: "Game Asset",
      description:
          "Data representing an asset for a game, such as an image or video.",
    ),
    "game_platform": const WebServiceAdapterType(
      key: "game_platform",
      name: "Game Platform",
      description: "Data representing a platform for game discovery.",
    ),
  };
}
