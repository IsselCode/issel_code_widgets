import 'package:flutter/material.dart';

/// Colores base que usa el tema predeterminado de Issel Code.
///
/// Estos valores sólo son defaults. Una aplicación puede proporcionar sus
/// propios colores a [IsselThemeColors.light] y [IsselThemeColors.dark].
abstract final class IsselColors {
  static const darkScaffoldBackground = Color(0xff0F101B);
  static const darkSurface = Color(0xff272832);
  static const lightScaffoldBackground = Color(0xffE5ECF4);
  static const lightSurface = Color(0xffF6F8FA);

  static const grey = Color(0xff727385);
  static const white = Color(0xffFFFFFF);
  static const darkWhite = Color(0xd3ffffff);
  static const black = Color(0xff000000);
  static const error = Colors.red;

  static const primary = Color(0xff0F52FF);
  static const darkPrimary = Color(0xff0046FF);
  static const secondary = Color(0xff1A3A9F);
}

/// Colores semánticos del tema Issel.
///
/// Los widgets del paquete no dependen de esta clase: leen el [ColorScheme]
/// del contexto. Esta clase sólo facilita construir un [ThemeData] coherente.
class IsselThemeColors {
  const IsselThemeColors({
    required this.brightness,
    required this.scaffoldBackground,
    required this.surface,
    required this.surfaceContainer,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.onError,
    required this.onSurface,
    required this.outline,
    this.outlineVariant,
  });

  /// Crea la paleta clara predeterminada.
  const IsselThemeColors.light({
    this.primary = IsselColors.primary,
    this.secondary = IsselColors.secondary,
    this.scaffoldBackground = IsselColors.lightScaffoldBackground,
    this.surface = IsselColors.lightSurface,
    this.surfaceContainer = IsselColors.lightScaffoldBackground,
    this.onPrimary = IsselColors.white,
    this.primaryContainer = IsselColors.white,
    this.onPrimaryContainer = IsselColors.white,
    this.onSecondary = IsselColors.black,
    this.error = IsselColors.error,
    this.onError = IsselColors.black,
    this.onSurface = IsselColors.black,
    this.outline = IsselColors.grey,
    this.outlineVariant,
  }) : brightness = Brightness.light;

  /// Crea la paleta oscura predeterminada.
  const IsselThemeColors.dark({
    this.primary = IsselColors.darkPrimary,
    this.secondary = IsselColors.secondary,
    this.scaffoldBackground = IsselColors.darkScaffoldBackground,
    this.surface = IsselColors.darkSurface,
    this.surfaceContainer = IsselColors.darkScaffoldBackground,
    this.onPrimary = IsselColors.darkWhite,
    this.primaryContainer = IsselColors.darkSurface,
    this.onPrimaryContainer = IsselColors.darkWhite,
    this.onSecondary = IsselColors.darkWhite,
    this.error = IsselColors.error,
    this.onError = IsselColors.darkWhite,
    this.onSurface = IsselColors.darkWhite,
    this.outline = IsselColors.grey,
    this.outlineVariant,
  }) : brightness = Brightness.dark;

  final Brightness brightness;
  final Color scaffoldBackground;
  final Color surface;
  final Color surfaceContainer;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color error;
  final Color onError;
  final Color onSurface;
  final Color outline;
  final Color? outlineVariant;

  /// Genera el esquema Material 3 usado por los widgets.
  ColorScheme get colorScheme {
    final generated = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    );

    return generated.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      surfaceContainer: surfaceContainer,
      onSurface: onSurface,
      outline: outline,
      outlineVariant: outlineVariant ?? generated.outlineVariant,
    );
  }

  /// Copia esta paleta cambiando sólo los valores indicados.
  IsselThemeColors copyWith({
    Brightness? brightness,
    Color? scaffoldBackground,
    Color? surface,
    Color? surfaceContainer,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? error,
    Color? onError,
    Color? onSurface,
    Color? outline,
    Color? outlineVariant,
  }) {
    return IsselThemeColors(
      brightness: brightness ?? this.brightness,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      surface: surface ?? this.surface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      onSurface: onSurface ?? this.onSurface,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
    );
  }
}

/// Tamaños y alturas de las variantes tipográficas del tema.
///
/// Todas las alturas parten de `1.0`. La aplicación puede aumentarlas de
/// forma individual o usar [fontSizeScale] para ajustar toda la escala.
class IsselTextThemeConfig {
  const IsselTextThemeConfig({
    this.fontSizeScale = 1.0,
    this.displayLargeHeight = 1.0,
    this.displayMediumHeight = 1.0,
    this.displaySmallHeight = 1.0,
    this.headlineLargeHeight = 1.0,
    this.headlineMediumHeight = 1.0,
    this.headlineSmallHeight = 1.0,
    this.titleLargeHeight = 1.0,
    this.titleMediumHeight = 1.0,
    this.titleSmallHeight = 1.0,
    this.bodyLargeHeight = 1.0,
    this.bodyMediumHeight = 1.0,
    this.bodySmallHeight = 1.0,
    this.labelLargeHeight = 1.0,
    this.labelMediumHeight = 1.0,
    this.labelSmallHeight = 1.0,
  });

  final double fontSizeScale;
  final double displayLargeHeight;
  final double displayMediumHeight;
  final double displaySmallHeight;
  final double headlineLargeHeight;
  final double headlineMediumHeight;
  final double headlineSmallHeight;
  final double titleLargeHeight;
  final double titleMediumHeight;
  final double titleSmallHeight;
  final double bodyLargeHeight;
  final double bodyMediumHeight;
  final double bodySmallHeight;
  final double labelLargeHeight;
  final double labelMediumHeight;
  final double labelSmallHeight;

  /// Construye el [TextTheme] predeterminado del paquete.
  TextTheme build({
    Color? onSurface,
    required Color outline,
  }) {
    final base = TextTheme(
      displayLarge: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        height: displayLargeHeight,
        letterSpacing: -1.1,
      ),
      displayMedium: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: displayMediumHeight,
        letterSpacing: -0.9,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: displaySmallHeight,
        letterSpacing: -0.7,
      ),
      headlineLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: headlineLargeHeight,
      ),
      headlineMedium: TextStyle(
        fontSize: 31,
        fontWeight: FontWeight.w700,
        height: headlineMediumHeight,
      ),
      headlineSmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: headlineSmallHeight,
      ),
      titleLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w700,
        height: titleLargeHeight,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: titleMediumHeight,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: titleSmallHeight,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: bodyLargeHeight,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: bodyMediumHeight,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: bodySmallHeight,
      ),
      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: labelLargeHeight,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: labelMediumHeight,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: labelSmallHeight,
      ),
    ).apply(
      bodyColor: onSurface,
      displayColor: onSurface,
      fontSizeFactor: fontSizeScale,
    );

    return base.copyWith(
      labelLarge: base.labelLarge?.copyWith(color: outline),
      labelMedium: base.labelMedium?.copyWith(color: outline),
      labelSmall: base.labelSmall?.copyWith(color: outline),
    );
  }

  /// Copia esta configuración tipográfica cambiando sólo los valores indicados.
  IsselTextThemeConfig copyWith({
    double? fontSizeScale,
    double? displayLargeHeight,
    double? displayMediumHeight,
    double? displaySmallHeight,
    double? headlineLargeHeight,
    double? headlineMediumHeight,
    double? headlineSmallHeight,
    double? titleLargeHeight,
    double? titleMediumHeight,
    double? titleSmallHeight,
    double? bodyLargeHeight,
    double? bodyMediumHeight,
    double? bodySmallHeight,
    double? labelLargeHeight,
    double? labelMediumHeight,
    double? labelSmallHeight,
  }) {
    return IsselTextThemeConfig(
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      displayLargeHeight: displayLargeHeight ?? this.displayLargeHeight,
      displayMediumHeight: displayMediumHeight ?? this.displayMediumHeight,
      displaySmallHeight: displaySmallHeight ?? this.displaySmallHeight,
      headlineLargeHeight: headlineLargeHeight ?? this.headlineLargeHeight,
      headlineMediumHeight: headlineMediumHeight ?? this.headlineMediumHeight,
      headlineSmallHeight: headlineSmallHeight ?? this.headlineSmallHeight,
      titleLargeHeight: titleLargeHeight ?? this.titleLargeHeight,
      titleMediumHeight: titleMediumHeight ?? this.titleMediumHeight,
      titleSmallHeight: titleSmallHeight ?? this.titleSmallHeight,
      bodyLargeHeight: bodyLargeHeight ?? this.bodyLargeHeight,
      bodyMediumHeight: bodyMediumHeight ?? this.bodyMediumHeight,
      bodySmallHeight: bodySmallHeight ?? this.bodySmallHeight,
      labelLargeHeight: labelLargeHeight ?? this.labelLargeHeight,
      labelMediumHeight: labelMediumHeight ?? this.labelMediumHeight,
      labelSmallHeight: labelSmallHeight ?? this.labelSmallHeight,
    );
  }
}

/// Configuración completa para generar un [ThemeData].
class IsselThemeConfig {
  const IsselThemeConfig({
    required this.colors,
    this.text = const IsselTextThemeConfig(),
    this.borderRadius = 10,
    this.cardBorderRadius = 16,
  });

  final IsselThemeColors colors;
  final IsselTextThemeConfig text;
  final double borderRadius;
  final double cardBorderRadius;

  /// Convierte esta configuración en un tema Material 3.
  ThemeData toThemeData() {
    final colorScheme = colors.colorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: colors.brightness,
      scaffoldBackgroundColor: colors.scaffoldBackground,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
        elevation: 1,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outline,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        tileColor: colors.surface,
      ),
      textTheme: text.build(
        onSurface: colors.onSurface,
        outline: colors.outline,
      ),
    );
  }

  IsselThemeConfig copyWith({
    IsselThemeColors? colors,
    IsselTextThemeConfig? text,
    double? borderRadius,
    double? cardBorderRadius,
  }) {
    return IsselThemeConfig(
      colors: colors ?? this.colors,
      text: text ?? this.text,
      borderRadius: borderRadius ?? this.borderRadius,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
    );
  }
}

/// Controlador opcional para mantener y cambiar el tema desde la aplicación.
///
/// Un uso típico es:
///
/// ```dart
/// final themeController = IsselThemeController(
///   lightColors: const IsselThemeColors.light(primary: Color(0xff7B1FA2)),
/// );
///
/// AnimatedBuilder(
///   animation: themeController,
///   builder: (_, __) => MaterialApp(
///     theme: themeController.lightTheme,
///     darkTheme: themeController.darkTheme,
///     themeMode: themeController.themeMode,
///     home: const HomePage(),
///   ),
/// );
/// ```
class IsselThemeController extends ChangeNotifier {
  IsselThemeController({
    IsselThemeConfig? light,
    IsselThemeConfig? dark,
    IsselThemeColors? lightColors,
    IsselThemeColors? darkColors,
    IsselTextThemeConfig text = const IsselTextThemeConfig(),
    ThemeMode themeMode = ThemeMode.system,
  })  : _light = light ??
            IsselThemeConfig(
              colors: lightColors ?? const IsselThemeColors.light(),
              text: text,
            ),
        _dark = dark ??
            IsselThemeConfig(
              colors: darkColors ?? const IsselThemeColors.dark(),
              text: text,
            ),
        _themeMode = themeMode;

  IsselThemeConfig _light;
  IsselThemeConfig _dark;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  IsselThemeConfig get lightConfig => _light;
  IsselThemeConfig get darkConfig => _dark;
  ThemeData get lightTheme => _light.toThemeData();
  ThemeData get darkTheme => _dark.toThemeData();

  /// Devuelve el tema correspondiente al brillo solicitado.
  ThemeData themeFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkTheme : lightTheme;

  /// Actualiza la configuración clara y notifica a los listeners.
  void updateLight(IsselThemeConfig config) {
    _light = config;
    notifyListeners();
  }

  /// Actualiza la configuración oscura y notifica a los listeners.
  void updateDark(IsselThemeConfig config) {
    _dark = config;
    notifyListeners();
  }

  /// Cambia únicamente la paleta clara.
  void updateLightColors(IsselThemeColors colors) {
    updateLight(_light.copyWith(colors: colors));
  }

  /// Cambia únicamente la paleta oscura.
  void updateDarkColors(IsselThemeColors colors) {
    updateDark(_dark.copyWith(colors: colors));
  }

  /// Cambia la tipografía clara sin modificar su paleta.
  void updateLightText(IsselTextThemeConfig text) {
    updateLight(_light.copyWith(text: text));
  }

  /// Cambia la tipografía oscura sin modificar su paleta.
  void updateDarkText(IsselTextThemeConfig text) {
    updateDark(_dark.copyWith(text: text));
  }

  /// Cambia la tipografía de ambas variantes del tema.
  void updateText(IsselTextThemeConfig text) {
    _light = _light.copyWith(text: text);
    _dark = _dark.copyWith(text: text);
    notifyListeners();
  }

  /// Cambia el modo claro, oscuro o del sistema.
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }
}
