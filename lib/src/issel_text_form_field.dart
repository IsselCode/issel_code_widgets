import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IsselTextFormField extends FormField<String> {
  final TextEditingController? controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final String hintText;
  final Color? fillColor;
  final bool obscureText;
  final IconData prefixIcon;
  final double height;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String value)? onSubmitted;
  final void Function(String value)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  IsselTextFormField({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.fillColor,
    this.height = 60,
    FormFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
  }) : super(
    validator: validator,
    autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
    builder: (state) {
      final theme = Theme.of(state.context);
      final textTheme = theme.textTheme;
      final colorScheme = theme.colorScheme;

      final s = state as _IsselTextFormFieldState;

      final ctrl = controller ?? TextEditingController(text: state.value ?? '');
      ctrl.addListener(() {
        if (!state.mounted) return; // evita llamar didChange después de dispose
        if (state.value != ctrl.text) {
          state.didChange(ctrl.text);
        }
      });

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(state.context).requestFocus(s._focusNode);
              onTap?.call();
            },
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: fillColor ?? colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              // Layout manual para evitar expansión del InputDecorator
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(prefixIcon, color: colorScheme.outline),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      inputFormatters: inputFormatters,
                      onSubmitted: onSubmitted,
                      onTap: onTap,
                      readOnly: readOnly,
                      controller: controller,
                      autofocus: autofocus,
                      focusNode: s._focusNode,
                      obscureText: obscureText && s.showPassword,
                      onChanged: onChanged != null ? (value) {
                        onChanged(value);
                        state.didChange(value);
                      } : null, // integra con el Form
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration.collapsed(
                        hintText: hintText,
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                  if (obscureText)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: IconButton(
                        constraints: BoxConstraints(maxWidth: 48, maxHeight: 48),
                        onPressed: () => state.setState(() {s.showPassword = !s.showPassword;}),
                        icon: Icon(Icons.remove_red_eye_outlined, color: colorScheme.outline,),
                      ),
                    ),
                  // const SizedBox(width: 8),
                ],
              ),
            ),
          ),

          // 👇 El error va DEBAJO del contenedor, no dentro del TextField
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

  @override
  IsselTextFormField get widget => super.widget as IsselTextFormField;

  @override
  void initState() {
    super.initState();
    // FocusNode: usar el externo o crear uno propio
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
    }
  }

}
