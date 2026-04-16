import 'package:flutter/material.dart';

/// Dropdown compatible con [Form] y validación.
///
/// Mantiene el valor dentro de un [FormField] para integrarse con
/// validadores y autovalidación.
class IsselDropdown2<T> extends FormField<T> {
  /// Valor inicial o seleccionado del campo.
  final T? value;

  /// Texto mostrado cuando no hay valor seleccionado.
  final String hintText;

  /// Opciones disponibles en el dropdown.
  final List<DropdownMenuItem<T>>? items;

  /// Callback invocado cuando cambia el valor seleccionado.
  final void Function(T?)? onChanged;

  /// Altura del contenedor del dropdown.
  final double height;

  /// Color de fondo opcional.
  ///
  /// Si es null, usa [ColorScheme.surface].
  final Color? color;

  /// Crea un dropdown de formulario con validación opcional.
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
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.outline),
                      ),
                      style: textTheme.bodyMedium,
                      padding: EdgeInsets.zero,
                      value: state.value, // 👈 USAR EL VALOR DEL FORM FIELD
                      borderRadius: BorderRadius.circular(10),
                      elevation: 3,
                      items: items,
                      onChanged: (newValue) {
                        state.didChange(newValue); // 👈 AVISAR AL FORM
                        onChanged?.call(newValue); // 👈 TU callback externo
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
