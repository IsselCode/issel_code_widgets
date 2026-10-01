## 0.0.49

* Added `IsselAppConfig` and `IsselAppController` to centralize app defaults,
  keeping an owned `IsselThemeController` and stable navigation instance.
* Added `IsselController` with disposal awareness for asynchronous presentation.
* Added configurable desktop scaffold, caption, compact caption buttons,
  breadcrumbs, and a controlled navigation pane inspired by PPG Trazabilidad.
* Added font family configuration and updated the example with an Issel feature,
  light/dark/system themes, and responsive desktop/mobile navigation.
* Fixed the header action subtitle and bounded long labels; made the example
  shimmer placeholders wrap on narrow screens.

## 0.0.48

* Added `IsselNavigationService` with typed route results, replacement, stack
  reset, route settings, and back requests that respect `PopScope`.
* Added the Dart-only `issel_core.dart` entrypoint with `AppException`,
  `AppFailure`, and sealed `AppResult<T>` success/error types.
* Kept core types out of the widget export to avoid conflicts with existing
  application exceptions and to support use from domain and data layers.

## 0.0.47

* Added `IsselThemeSelector` for responsive light, dark, and system theme
  selection with configurable labels, descriptions, and persistence callback.

## 0.0.46

* Deferred overlay refreshes in `IsselSearchDropdown` until after the current
  frame to avoid state errors when search results update while it is open.

## 0.0.45

* Added configurable overlay rendering to `IsselSearchDropdown`.
* Added configurable Issel colors, text metrics, default themes, and theme controller.

## 0.0.43

* Added `IsselFilterBar` and `IsselFilterOption` for horizontal filter selection.
* Added multiline configuration to `IsselTextFormField`.
* Added configurable `IsselImagePicker`.
* Added configurable image clearing with `showClearButton`.
* Updated `shimmer` to 4.0.0 and `flutter_lints` to 6.0.0.

## 0.0.1

* TODO: Describe initial release.
