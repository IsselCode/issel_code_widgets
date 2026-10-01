import 'package:issel_code_widgets/issel_code_widgets.dart';

/// Punto único para los valores del kit que personaliza esta aplicación.
class AppIsselController extends IsselAppController {
  AppIsselController()
      : super(
          config: const IsselAppConfig(
            title: 'Issel Code Widgets',
            lightTheme: IsselThemeConfig(
              colors: IsselThemeColors.light(),
              text: IsselTextThemeConfig(bodyMediumHeight: 1.15),
            ),
            darkTheme: IsselThemeConfig(
              colors: IsselThemeColors.dark(),
              text: IsselTextThemeConfig(bodyMediumHeight: 1.15),
            ),
            desktop: IsselDesktopConfig(sidebarWidth: 190, captionHeight: 32),
          ),
        );
}
