import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo numérico con botones para incrementar y decrementar.
///
/// Mantiene el valor dentro del rango definido por [minValue] y [maxValue], y
/// notifica los cambios mediante [onChanged].
class IsselStepperField extends StatefulWidget {
  /// Valor inicial del campo.
  final double initValue;

  /// Texto descriptivo mostrado junto al contador.
  final String title;

  /// Altura total del campo.
  final double height;

  /// Color de fondo opcional del campo.
  final Color? backColor;

  /// Color de fondo opcional del contador.
  final Color? counterColor;

  /// Valor máximo permitido.
  final int maxValue;

  /// Valor mínimo permitido.
  final int minValue;

  /// Callback invocado cuando cambia el valor.
  final ValueChanged<double> onChanged;

  /// Crea un campo numérico con controles de incremento.
  ///
  /// [minValue] debe ser menor o igual que [maxValue].
  IsselStepperField(
      {super.key,
      required this.title,
      required this.minValue,
      required this.maxValue,
      required this.onChanged,
      this.initValue = 0,
      this.height = 50,
      this.backColor,
      this.counterColor})
      : assert(minValue <= maxValue, 'minValue debe ser <= maxValue');

  @override
  State<IsselStepperField> createState() => _TestStepperFieldState();
}

class _TestStepperFieldState extends State<IsselStepperField> {
  FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
    delta.text = widget.initValue.toString();
    oldDelta = widget.initValue;
    focus.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    focus.removeListener(_handleFocusChange);
    focus.dispose();
    delta.dispose();
    super.dispose();
  }

  late double oldDelta;
  final TextEditingController delta = TextEditingController();

  void _handleFocusChange() {
    if (!focus.hasFocus) {
      onSubmitted(delta.text);
    }
  }

  void toggleDelta(double value) {
    if (delta.text.isEmpty || value == "-" || value == ".") {
      delta.text = oldDelta.toString();
    }
    double tempValue = double.parse(delta.text);
    tempValue += value;
    double resultado =
        tempValue.clamp(widget.minValue, widget.maxValue).toDouble();
    delta.text = resultado.toString();
    oldDelta = resultado;
    widget.onChanged.call(double.parse(delta.text));
    setState(() {});
  }

  void onChanged(String value) {
    if (value.isEmpty || value == "-" || value == ".") return;

    final parsed = double.tryParse(value);
    if (parsed == null) return;

    if (parsed > widget.maxValue) {
      double resultado =
          parsed.clamp(widget.minValue, widget.maxValue).toDouble();
      delta.text = resultado.toString();
      oldDelta = resultado;
      widget.onChanged.call(double.parse(delta.text));
      setState(() {});
    }
  }

  void onSubmitted(String value) {
    if (delta.text.isEmpty ||
        (delta.text.length == 1 && delta.text.contains("-"))) {
      delta.text = oldDelta.toString();
    }

    final parsed = double.tryParse(value);
    if (parsed == null) return;
    double resultado =
        parsed.clamp(widget.minValue, widget.maxValue).toDouble();
    delta.text = resultado.toString();
    oldDelta = resultado;
    widget.onChanged.call(double.parse(delta.text));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Container(
      height: widget.height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: widget.backColor ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          // Text
          Expanded(child: Text(widget.title)),

          // Counter
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: widget.counterColor ?? theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () => toggleDelta(-1),
                    icon: Icon(Icons.remove_outlined)),
                Expanded(
                  child: TextField(
                    focusNode: focus,
                    controller: delta,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    onSubmitted: onSubmitted,
                    onChanged: onChanged,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^-?\d*([.]\d*)?$')),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: oldDelta.toString(),
                      hintStyle: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.outline),
                      isCollapsed: true,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => toggleDelta(1),
                    icon: Icon(Icons.add_outlined))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
