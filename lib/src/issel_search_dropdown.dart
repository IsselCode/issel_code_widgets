import 'package:flutter/material.dart';

import '../issel_code_widgets.dart' show IsselTextFormField;

/// Dropdown personalizado con campo de búsqueda integrado.
///
/// Muestra el elemento seleccionado como encabezado y despliega una lista de
/// opciones junto con un campo para reportar búsquedas externas.
class IsselSearchDropdown<T> extends StatefulWidget {
  /// Valor seleccionado actualmente.
  final T? value;

  /// Texto mostrado cuando no hay valor seleccionado.
  final String hintText;

  /// Opciones disponibles en el dropdown.
  final List<DropdownMenuItem<T>>? items;

  /// Callback invocado cuando cambia el valor seleccionado.
  final void Function(T?)? onChanged;

  /// Altura del encabezado del dropdown.
  final double height;

  /// Color de fondo opcional.
  ///
  /// Si es null, usa [ColorScheme.surface].
  final Color? color;

  /// Callback invocado mientras cambia el texto de búsqueda.
  final ValueChanged<String>? onSearchChanged;

  /// Callback invocado al enviar el texto de búsqueda.
  final ValueChanged<String>? onSearchSubmitted;

  /// Límite opcional de ítems visibles en la lista desplegada.
  final int? maxItemsToShow;

  /// Crea un dropdown con búsqueda y opciones seleccionables.
  const IsselSearchDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.height = 50,
    this.value,
    this.color,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.maxItemsToShow,
  });

  @override
  State<IsselSearchDropdown<T>> createState() =>
      _CustomSearchDropdownState<T>();
}

class _CustomSearchDropdownState<T> extends State<IsselSearchDropdown<T>> {
  bool _isOpen = false;
  FocusNode textFormFieldFocus = FocusNode();
  T? hoverValue;

  void _toggleOpen() {
    setState(() => _isOpen = !_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Buscar el item seleccionado para mostrar su child
    Widget? selectedChild;
    if (widget.value != null && widget.items != null) {
      try {
        selectedChild =
            widget.items!.firstWhere((e) => e.value == widget.value).child;
      } catch (_) {}
    }

    final visibleItems = widget.items ?? [];

    final int itemCount = widget.maxItemsToShow == null
        ? visibleItems.length
        : visibleItems.length.clamp(0, widget.maxItemsToShow!);

    // Altura calculada según cantidad limitada
    const double itemHeight = 45;
    final double listMaxHeight = itemCount * itemHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- "Cabeza" del dropdown ---
        Container(
          height: widget.height,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: widget.color ?? colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            borderRadius: BorderRadius.circular(10),
            onTap: _toggleOpen,
            child: Row(
              children: [
                Expanded(
                  child: selectedChild ??
                      Text(
                        widget.hintText,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.outline),
                      ),
                ),
                Icon(
                  _isOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.outline,
                ),
              ],
            ),
          ),
        ),

        if (_isOpen) const SizedBox(height: 4),

        //* Contenido desplegado
        if (_isOpen)
          Container(
            width: double.infinity,
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.color ?? colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                  color: Colors.black.withOpacity(0.15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //* Campo de búsqueda
                IsselTextFormField(
                  hintText: 'Buscar',
                  autofocus: true,
                  focusNode: textFormFieldFocus,
                  height: 40,
                  prefixIcon: Icons.search,
                  onChanged: widget.onSearchChanged,
                  onSubmitted: (value) {
                    widget.onSearchSubmitted?.call(value);
                    textFormFieldFocus.requestFocus();
                  },
                ),

                const SizedBox(height: 8),

                //* Lista de opciones con límite opcional
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: listMaxHeight.clamp(80, 250).toDouble(),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final item = visibleItems[index];

                      return InkWell(
                        onTap: () {
                          widget.onChanged?.call(item.value);
                          setState(() => _isOpen = false);
                        },
                        onHover: (value) {
                          if (value) {
                            hoverValue = item.value;
                          } else {
                            hoverValue = null;
                          }
                          setState(() {});
                        },
                        mouseCursor: SystemMouseCursors.click,
                        child: ClipRRect(
                          borderRadius: index + 1 == itemCount
                              ? BorderRadius.vertical(
                                  bottom: Radius.circular(10))
                              : BorderRadius.zero,
                          child: ColoredBox(
                            color: widget.value == item.value
                                ? colorScheme.inverseSurface.withAlpha(25)
                                : hoverValue == item.value
                                    ? colorScheme.inverseSurface.withAlpha(15)
                                    : Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: DefaultTextStyle(
                                style: textTheme.bodyMedium ??
                                    const TextStyle(fontSize: 14),
                                child: item.child,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
