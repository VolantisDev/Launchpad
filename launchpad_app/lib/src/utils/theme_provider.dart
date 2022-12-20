import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../theme.dart';

part 'theme_provider.g.dart';

@riverpod
AppTheme appTheme(AppThemeRef ref) {
  return AppTheme();
}
