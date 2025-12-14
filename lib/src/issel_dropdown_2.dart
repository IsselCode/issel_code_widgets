import 'package:flutter/material.dart';

class IsselDropdown2<T> extends FormField<T> {
  final T? value;
  final String hintText;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final double height;
  final Color? color;

  IsselDropdown2({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.height = 50,
    this.value,
    this.color,
    FormFieldValidator<T>? validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
    initialValue: value,
    validator: validator,
    autovalidateMode: autovalidateMode,
    builder: (FormFieldState<T> state) {
      final theme = Theme.of(state.context);
      final textTheme = theme.textTheme;
      final colorScheme = theme.colorScheme;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: color ?? colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                hint: Text(
                  hintText,
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                ),
                style: textTheme.bodyMedium,
                padding: EdgeInsets.zero,
                value: state.value, // 👈 USAR EL VALOR DEL FORM FIELD
                borderRadius: BorderRadius.circular(10),
                elevation: 3,
                items: items,
                onChanged: (newValue) {
                  state.didChange(newValue); // 👈 AVISAR AL FORM
                  onChanged?.call(newValue);  // 👈 TU callback externo
                },
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
}
