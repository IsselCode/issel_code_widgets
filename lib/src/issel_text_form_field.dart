import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de texto estilizado compatible con [Form].
///
/// Puede funcionar con un [TextEditingController] externo o crear uno interno,
/// y sincroniza los cambios con el estado del [FormField].
class IsselTextFormField extends FormField<String> {
  /// Controlador externo opcional del texto.
  final TextEditingController? controller;

  /// Indica si el campo debe solicitar foco automáticamente.
  final bool autofocus;

  /// Nodo de foco externo opcional.
  final FocusNode? focusNode;

  /// Texto de ayuda mostrado cuando el campo está vacío.
  final String hintText;

  /// Color de relleno opcional.
  final Color? fillColor;

  /// Indica si el texto debe ocultarse como contraseña.
  final bool obscureText;

  /// Icono opcional mostrado al inicio del campo.
  final IconData? prefixIcon;

  /// Altura del campo.
  final double height;

  /// Indica si el campo es de solo lectura.
  final bool readOnly;

  /// Callback invocado al tocar el campo.
  final VoidCallback? onTap;

  /// Callback invocado al enviar el texto.
  final void Function(String value)? onSubmitted;

  /// Alineación horizontal del texto.
  final TextAlign? textAlign;

  /// Estilo opcional del texto escrito.
  final TextStyle? style;

  /// Callback invocado cuando cambia el texto.
  final void Function(String value)? onChanged;

  /// Formateadores aplicados al texto ingresado.
  final List<TextInputFormatter>? inputFormatters;

  /// Crea un campo de texto de formulario.
  IsselTextFormField({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.onTap,
    this.textAlign,
    this.style,
    this.inputFormatters,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.fillColor,
    this.height = 60,
    FormFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
  }) : super(
          initialValue: controller?.text ?? "",
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (state) {
            final theme = Theme.of(state.context);
            final textTheme = theme.textTheme;
            final colorScheme = theme.colorScheme;

            final s = state as _IsselTextFormFieldState;
            final ctrl = s._controller; // controlador estable

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(state.context).requestFocus(s._focusNode);
                    s.widget.onTap?.call();
                  },
                  child: Container(
                    height: s.widget.height,
                    decoration: BoxDecoration(
                      color: s.widget.fillColor ?? colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        if (s.widget.prefixIcon != null) ...[
                          const SizedBox(width: 8),
                          Icon(s.widget.prefixIcon, color: colorScheme.outline),
                        ],
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: ctrl,
                            focusNode: s._focusNode,
                            autofocus: s.widget.autofocus,
                            readOnly: s.widget.readOnly,
                            inputFormatters: s.widget.inputFormatters,
                            onSubmitted: s.widget.onSubmitted,
                            onTap: s.widget.onTap,
                            obscureText: s.widget.obscureText && s.showPassword,
                            maxLines: 1,
                            textAlignVertical:
                                defaultTargetPlatform == TargetPlatform.windows
                                    ? null
                                    : TextAlignVertical.center,
                            textAlign: s.widget.textAlign ?? TextAlign.start,
                            style: s.widget.style,
                            decoration: InputDecoration.collapsed(
                              hintText: s.widget.hintText,
                              hintStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                        if (s.widget.obscureText)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: IconButton(
                              constraints: const BoxConstraints(
                                  maxWidth: 48, maxHeight: 48),
                              onPressed: () => state.setState(() {
                                s.showPassword = !s.showPassword;
                              }),
                              icon: Icon(Icons.remove_red_eye_outlined,
                                  color: colorScheme.outline),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );

  @override
  FormFieldState<String> createState() => _IsselTextFormFieldState();
}

class _IsselTextFormFieldState extends FormFieldState<String> {
  bool showPassword = true;
  late FocusNode _focusNode;

  TextEditingController? _internalController;

  TextEditingController get _controller =>
      widget.controller ??
      (_internalController ??= TextEditingController(text: value ?? ''));

  @override
  IsselTextFormField get widget => super.widget as IsselTextFormField;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    // Listener único: de aquí actualizamos FormField + onChanged
    _controller.addListener(_handleControllerChanged);

    final text = _controller.text;
    if (value != text) {
      setValue(text);
    }
  }

  void _handleControllerChanged() {
    if (!mounted) return;
    final text = _controller.text;

    // Actualiza el FormField SIN tocar el controller (evita loops/IME issues)
    if (value != text) {
      setValue(text); // <-- en vez de didChange()
      widget.onChanged?.call(text);
    }
  }

  @override
  void didUpdateWidget(IsselTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      // quitar listener del anterior
      (oldWidget.controller ?? _internalController)
          ?.removeListener(_handleControllerChanged);

      // poner listener al nuevo
      _controller.addListener(_handleControllerChanged);

      // opcional: si el nuevo controller viene vacío, sincroniza con el value actual
      final current = value ?? '';
      if (_controller.text != current && _controller.text.isEmpty) {
        _controller.text = current;
      }
    }
  }

  @override
  void reset() {
    super.reset();
    // Si el form se resetea, aquí sí sincronizamos controller (programático, no por IME)
    final text = value ?? '';
    if (_controller.text != text) {
      _controller.value = _controller.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
        // NO borres composing aquí tampoco; pero en reset normalmente no importa.
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }
}
