import 'package:fluent_ui/fluent_ui.dart';

class WebServiceAuthenticator {
  WebServiceAuthenticator({
    required this.name,
    required this.description,
    required this.fields,
  });

  final String name;
  final String description;
  final List<AuthField> fields;

  Future<Map<String, String>> authenticate(
      Map<String, String> credentials) async {
    return {};
  }
}

class AuthField {
  AuthField({
    required this.key,
    required this.name,
    this.description = '',
    this.placeholder = '',
    this.value = '',
    this.expands = false,
    this.obscureText = false,
  });

  final String key;
  final String name;
  final String description;
  final String placeholder;
  final bool expands;
  final bool obscureText;
  String value;
  Widget? widget;

  Future<Widget> getWidget() async {
    widget ??= TextBox(
      header: name,
      placeholder: placeholder,
      expands: expands,
      initialValue: value,
      obscureText: obscureText,
    );

    return widget!;
  }
}
