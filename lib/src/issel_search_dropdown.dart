import 'package:flutter/material.dart';

import '../issel_code_widgets.dart' show IsselTextFormField;

/// Dropdown personalizado con campo de búsqueda integrado.
///
/// Puede expandir su contenido dentro del layout o mostrarlo como overlay.
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
  final Color? color;

  /// Callback invocado mientras cambia el texto de búsqueda.
  final ValueChanged<String>? onSearchChanged;

  /// Callback invocado al enviar el texto de búsqueda.
  final ValueChanged<String>? onSearchSubmitted;

  /// Límite opcional de ítems visibles en la lista desplegada.
  final int? maxItemsToShow;

  /// Muestra la lista sobre el contenido sin cambiar la altura del layout.
  ///
  /// El valor predeterminado es `false`, que conserva el comportamiento
  /// expandible del widget.
  final bool overlay;

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
    this.overlay = false,
  });

  @override
  State<IsselSearchDropdown<T>> createState() =>
      _CustomSearchDropdownState<T>();
}

class _CustomSearchDropdownState<T> extends State<IsselSearchDropdown<T>> {
  bool _isOpen = false;
  final _headerKey = GlobalKey();
  final _layerLink = LayerLink();
  final _searchFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  T? hoverValue;

  void _scheduleOverlayRefresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _overlayEntry?.markNeedsBuild();
    });
  }

  void _toggleOpen() {
    if (_isOpen) {
      _closeDropdown();
      return;
    }

    setState(() => _isOpen = true);
    if (widget.overlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isOpen) _showOverlay();
      });
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeDropdown,
              child: const SizedBox.expand(),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, widget.height + 4),
            child: Material(
              type: MaterialType.transparency,
              child: SizedBox(
                width: _headerWidth,
                child: _buildDropdownContent(context),
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(_overlayEntry!);
    _searchFocusNode.requestFocus();
  }

  double get _headerWidth {
    final renderObject = _headerKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      return renderObject.size.width;
    }
    return 280;
  }

  void _removeOverlay() {
    final entry = _overlayEntry;
    _overlayEntry = null;
    entry?.remove();
  }

  void _closeDropdown() {
    final wasOpen = _isOpen;
    _isOpen = false;
    _removeOverlay();
    _searchFocusNode.unfocus();
    if (wasOpen && mounted) setState(() {});
  }

  void _selectItem(T? value) {
    _closeDropdown();
    widget.onChanged?.call(value);
  }

  @override
  void didUpdateWidget(covariant IsselSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.overlay != widget.overlay) {
      if (widget.overlay && _isOpen) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isOpen) _showOverlay();
        });
      } else if (!widget.overlay) {
        _removeOverlay();
      }
    }
    _scheduleOverlayRefresh();
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Widget? selectedChild;
    if (widget.value != null && widget.items != null) {
      try {
        selectedChild = widget.items!
            .firstWhere((item) => item.value == widget.value)
            .child;
      } catch (_) {}
    }

    return Container(
      key: _headerKey,
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
              child:
                  selectedChild ??
                  Text(
                    widget.hintText,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.outline,
                    ),
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
    );
  }

  Widget _buildDropdownContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final visibleItems = widget.items ?? <DropdownMenuItem<T>>[];
    final itemCount = widget.maxItemsToShow == null
        ? visibleItems.length
        : visibleItems.length.clamp(0, widget.maxItemsToShow!);

    const itemHeight = 45.0;
    final listMaxHeight = itemCount * itemHeight;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 3),
            color: const Color.fromRGBO(0, 0, 0, 0.15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IsselTextFormField(
            hintText: 'Buscar',
            autofocus: true,
            focusNode: _searchFocusNode,
            height: 40,
            prefixIcon: Icons.search,
            onChanged: widget.onSearchChanged,
            onSubmitted: (value) {
              widget.onSearchSubmitted?.call(value);
              _searchFocusNode.requestFocus();
            },
          ),
          const SizedBox(height: 8),
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
                    _selectItem(item.value);
                  },
                  onHover: (value) {
                    hoverValue = value ? item.value : null;
                    if (mounted) setState(() {});
                    _scheduleOverlayRefresh();
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: ClipRRect(
                    borderRadius: index + 1 == itemCount
                        ? const BorderRadius.vertical(
                            bottom: Radius.circular(10),
                          )
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
                          style:
                              textTheme.bodyMedium ??
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = CompositedTransformTarget(
      link: _layerLink,
      child: _buildHeader(context),
    );

    if (widget.overlay) return header;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        header,
        if (_isOpen) const SizedBox(height: 4),
        if (_isOpen) _buildDropdownContent(context),
      ],
    );
  }
}
