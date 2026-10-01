/// Valores de composición personalizables para el shell de escritorio.
class IsselDesktopConfig {
  const IsselDesktopConfig({
    this.sidebarWidth = 190,
    this.captionHeight = 32,
    this.sidebarBreakpoint = 900,
    this.animationDuration = const Duration(milliseconds: 180),
  })  : assert(sidebarWidth > 0),
        assert(captionHeight >= 28),
        assert(sidebarBreakpoint > sidebarWidth);

  final double sidebarWidth;
  final double captionHeight;
  final double sidebarBreakpoint;
  final Duration animationDuration;

  IsselDesktopConfig copyWith({
    double? sidebarWidth,
    double? captionHeight,
    double? sidebarBreakpoint,
    Duration? animationDuration,
  }) =>
      IsselDesktopConfig(
        sidebarWidth: sidebarWidth ?? this.sidebarWidth,
        captionHeight: captionHeight ?? this.captionHeight,
        sidebarBreakpoint: sidebarBreakpoint ?? this.sidebarBreakpoint,
        animationDuration: animationDuration ?? this.animationDuration,
      );
}
