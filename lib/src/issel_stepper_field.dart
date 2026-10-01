import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo numérico con botones para incrementar y decrementar.
///
/// Mantiene el valor dentro del rango definido por [minValue] y [maxValue], y
/// notifica los cambios mediante [onChanged]. [step] también puede ser
/// decimal, por ejemplo `0.1`.
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
  final num maxValue;

  /// Valor mínimo permitido.
  final num minValue;

  /// Incremento o decremento aplicado por los botones.
  final num step;

  /// Callback invocado cuando cambia el valor.
  final ValueChanged<double> onChanged;

  /// Crea un campo numérico con controles de incremento.
  ///
  /// [minValue] debe ser menor o igual que [maxValue]. [step] debe ser mayor
  /// que cero y puede ser decimal.
  const IsselStepperField({
    super.key,
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    this.initValue = 0,
    this.step = 1,
    this.height = 50,
    this.backColor,
    this.counterColor,
  })  : assert(minValue <= maxValue, 'minValue debe ser <= maxValue'),
        assert(step > 0, 'step debe ser mayor que cero');

  @override
  State<IsselStepperField> createState() => _IsselStepperFieldState();
}

class _IsselStepperFieldState extends State<IsselStepperField> {
  final FocusNode focus = FocusNode();
  final TextEditingController delta = TextEditingController();
  late double oldDelta;

  @override
  void initState() {
    super.initState();
    oldDelta = _clamp(widget.initValue);
    delta.text = _formatValue(oldDelta);
    focus.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant IsselStepperField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initValue != widget.initValue && !focus.hasFocus) {
      _setValue(widget.initValue, notify: false);
    }
  }

  @override
  void dispose() {
    focus.removeListener(_handleFocusChange);
    focus.dispose();
    delta.dispose();
    super.dispose();
  }

  double _clamp(double value) {
    final result = value
        .clamp(widget.minValue.toDouble(), widget.maxValue.toDouble())
        .toDouble();
    return double.parse(result.toStringAsFixed(10));
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  void _setValue(double value, {required bool notify}) {
    oldDelta = _clamp(value);
    delta.text = _formatValue(oldDelta);
    if (notify) widget.onChanged(oldDelta);
  }

  void _handleFocusChange() {
    if (!focus.hasFocus) onSubmitted(delta.text);
  }

  void toggleDelta(double direction) {
    final current = double.tryParse(delta.text) ?? oldDelta;
    _setValue(current + direction * widget.step.toDouble(), notify: true);
    setState(() {});
  }

  void onChanged(String value) {
    if (value.isEmpty || value == '-' || value == '.') return;

    final parsed = double.tryParse(value);
    if (parsed == null) return;

    if (parsed < widget.minValue || parsed > widget.maxValue) {
      _setValue(parsed, notify: true);
      setState(() {});
    }
  }

  void onSubmitted(String value) {
    if (value.isEmpty || (value.length == 1 && value.contains('-'))) {
      _setValue(oldDelta, notify: true);
      return;
    }

    final parsed = double.tryParse(value);
    if (parsed == null) {
      _setValue(oldDelta, notify: true);
      return;
    }

    _setValue(parsed, notify: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      height: widget.height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: widget.backColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: Text(widget.title)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: widget.counterColor ?? colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => toggleDelta(-1),
                    icon: const Icon(Icons.remove_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: focus,
                      controller: delta,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      onSubmitted: onSubmitted,
                      onChanged: onChanged,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^-?\d*([.]\d*)?$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _formatValue(oldDelta),
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                        isCollapsed: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => toggleDelta(1),
                    icon: const Icon(Icons.add_outlined),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
