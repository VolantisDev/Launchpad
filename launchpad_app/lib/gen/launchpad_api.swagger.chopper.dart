// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launchpad_api.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$LaunchpadApi extends LaunchpadApi {
  _$LaunchpadApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = LaunchpadApi;

  @override
  Future<Response<String>> _helloGet() {
    final Uri $url = Uri.parse('/hello');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Status>> _statusGet() {
    final Uri $url = Uri.parse('/status');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Status, Status>($request);
  }

  @override
  Future<Response<ReleaseInfo>> _releaseInfoGet() {
    final Uri $url = Uri.parse('/release-info');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<ReleaseInfo, ReleaseInfo>($request);
  }

  @override
  Future<Response<List<Object>>> _platformsGet() {
    final Uri $url = Uri.parse('/platforms');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Object>, Object>($request);
  }

  @override
  Future<Response<PlatformDocument>> _platformsPlatformIdGet(
      {required String? platformId}) {
    final Uri $url = Uri.parse('/platforms/${platformId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<PlatformDocument, PlatformDocument>($request);
  }

  @override
  Future<Response<List<Object>>> _launcherTypesGet() {
    final Uri $url = Uri.parse('/launcher-types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Object>, Object>($request);
  }

  @override
  Future<Response<LauncherTypeDocument>> _launcherTypesLauncherTypeIdGet(
      {required String? launcherTypeId}) {
    final Uri $url = Uri.parse('/launcher-types/${launcherTypeId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<LauncherTypeDocument, LauncherTypeDocument>($request);
  }

  @override
  Future<Response<List<Object>>> _gameTypesGet() {
    final Uri $url = Uri.parse('/game-types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Object>, Object>($request);
  }

  @override
  Future<Response<GameTypeDocument>> _gameTypesGameTypeIdGet(
      {required String? gameTypeId}) {
    final Uri $url = Uri.parse('/game-types/${gameTypeId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<GameTypeDocument, GameTypeDocument>($request);
  }

  @override
  Future<Response<List<Object>>> _gamesGet() {
    final Uri $url = Uri.parse('/games');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Object>, Object>($request);
  }

  @override
  Future<Response<List<String>>> _gameKeysGet() {
    final Uri $url = Uri.parse('/game-keys');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<String>, String>($request);
  }

  @override
  Future<Response<GameDocument>> _gamesGameIdGet({required String? gameId}) {
    final Uri $url = Uri.parse('/games/${gameId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<GameDocument, GameDocument>($request);
  }

  @override
  Future<Response<Object>> _lookupGameKeyPlatformIdGet({
    required String? gameKey,
    required String? platformId,
  }) {
    final Uri $url = Uri.parse('/lookup/${gameKey}/${platformId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<dynamic>> _submitErrorPost({
    required String? message,
    required String? what,
    required String? file,
    required int? line,
    String? extra,
    String? stack,
    String? email,
    String? details,
    String? version,
  }) {
    final Uri $url = Uri.parse('/submit-error');
    final Map<String, dynamic> $params = <String, dynamic>{
      'message': message,
      'what': what,
      'file': file,
      'line': line,
      'extra': extra,
      'stack': stack,
      'email': email,
      'details': details,
      'version': version,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _submitFeedbackPost({
    required String? feedback,
    String? email,
    String? version,
  }) {
    final Uri $url = Uri.parse('/submit-feedback');
    final Map<String, dynamic> $params = <String, dynamic>{
      'feedback': feedback,
      'email': email,
      'version': version,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
