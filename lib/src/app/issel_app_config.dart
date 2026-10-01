import 'package:flutter/material.dart';

import '../desktop/issel_desktop_config.dart';
import '../theme/issel_theme.dart';

/// Configuración del kit. Los valores de cada producto viven en su feature Issel.
class IsselAppConfig {
  const IsselAppConfig({
    this.title = 'Issel Code',
    this.lightTheme = const IsselThemeConfig(colors: IsselThemeColors.light()),
    this.darkTheme = const IsselThemeConfig(colors: IsselThemeColors.dark()),
    this.themeMode = ThemeMode.system,
    this.desktop = const IsselDesktopConfig(),
  });

  final String title;
  final IsselThemeConfig lightTheme;
  final IsselThemeConfig darkTheme;
  final ThemeMode themeMode;
  final IsselDesktopConfig desktop;

  IsselAppConfig copyWith({
    String? title,
    IsselThemeConfig? lightTheme,
    IsselThemeConfig? darkTheme,
    ThemeMode? themeMode,
    IsselDesktopConfig? desktop,
  }) =>
      IsselAppConfig(
        title: title ?? this.title,
        lightTheme: lightTheme ?? this.lightTheme,
        darkTheme: darkTheme ?? this.darkTheme,
        themeMode: themeMode ?? this.themeMode,
        desktop: desktop ?? this.desktop,
      );
}
