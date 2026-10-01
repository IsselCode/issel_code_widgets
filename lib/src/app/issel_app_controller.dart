import '../navigation/issel_navigation_service.dart';
import '../presentation/issel_controller.dart';
import '../theme/issel_theme.dart';
import 'issel_app_config.dart';

/// Composición estable de configuración, tema y navegación para una app Issel.
///
/// La app puede extender esta clase en `src/issel/presentation/controllers/`
/// para concentrar sus defaults. Este controlador posee y libera [theme];
/// la instancia de navegación se conserva al cambiar la configuración.
class IsselAppController extends IsselController {
  IsselAppController({
    IsselAppConfig config = const IsselAppConfig(),
    IsselNavigationService? navigation,
  })  : _config = config,
        theme = IsselThemeController(
          light: config.lightTheme,
          dark: config.darkTheme,
          themeMode: config.themeMode,
        ),
        navigation = navigation ?? IsselNavigationService() {
    theme.addListener(_onThemeChanged);
  }

  IsselAppConfig _config;
  bool _updatingConfig = false;

  final IsselThemeController theme;
  final IsselNavigationService navigation;

  IsselAppConfig get config => _config;

  void _onThemeChanged() {
    if (_updatingConfig || isDisposed) return;
    _config = _config.copyWith(
      lightTheme: theme.lightConfig,
      darkTheme: theme.darkConfig,
      themeMode: theme.themeMode,
    );
    notifyIfActive();
  }

  /// Aplica los nuevos defaults sin sustituir el tema ni la clave de navegación.
  void updateConfig(IsselAppConfig config) {
    if (isDisposed) throw StateError('IsselAppController ya fue liberado.');
    _updatingConfig = true;
    try {
      theme.updateLight(config.lightTheme);
      theme.updateDark(config.darkTheme);
      theme.setThemeMode(config.themeMode);
      _config = config;
    } finally {
      _updatingConfig = false;
    }
    notifyIfActive();
  }

  @override
  void dispose() {
    if (isDisposed) return;
    theme.removeListener(_onThemeChanged);
    theme.dispose();
    super.dispose();
  }
}
