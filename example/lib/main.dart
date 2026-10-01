import 'package:flutter/material.dart';

import 'src/issel/presentation/controllers/app_issel_controller.dart';
import 'src/issel/presentation/views/issel_workspace.dart';

void main() => runApp(const WidgetsExampleApp());

class WidgetsExampleApp extends StatefulWidget {
  const WidgetsExampleApp({super.key});

  @override
  State<WidgetsExampleApp> createState() => _WidgetsExampleAppState();
}

class _WidgetsExampleAppState extends State<WidgetsExampleApp> {
  final _issel = AppIsselController();

  @override
  void dispose() {
    _issel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _issel,
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: _issel.config.title,
          theme: _issel.theme.lightTheme,
          darkTheme: _issel.theme.darkTheme,
          themeMode: _issel.theme.themeMode,
          navigatorKey: _issel.navigation.navigatorKey,
          home: IsselWorkspace(app: _issel),
        ),
      );
}
