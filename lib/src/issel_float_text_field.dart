import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'issel_text_form_field.dart';

/// Campo de texto que abre un editor flotante al tocarse.
///
/// Muestra un [IsselTextFormField] de solo lectura y sincroniza el texto del
/// editor flotante con [controller] cuando el usuario confirma el valor.
class IsselFloatTextField extends StatefulWidget {
  /// Controlador que almacena el texto del campo.
  final TextEditingController controller;

  /// Texto de ayuda mostrado cuando el campo está vacío.
  final String hintText;

  /// Icono mostrado al inicio del campo.
  final IconData prefixIcon;

  /// Indica si el texto debe ocultarse como contraseña.
  final bool obscureText;

  /// Color de relleno opcional del campo.
  final Color? fillColor;

  /// Altura del campo.
  final double height;

  /// Validador opcional usado por el campo visible.
  final FormFieldValidator<String>? validator;

  /// Callback invocado cuando cambia el texto.
  final void Function(String value)? onChanged;

  /// Callback invocado cuando se envía el texto.
  final void Function(String value)? onSubmitted;

  /// Crea un campo de texto con editor flotante.
  const IsselFloatTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.prefixIcon,
      this.obscureText = false,
      this.fillColor,
      this.height = 60,
      this.validator,
      this.onChanged,
      this.onSubmitted});

  @override
  State<IsselFloatTextField> createState() => _IsselFloatTextFieldState();
}

class _IsselFloatTextFieldState extends State<IsselFloatTextField> {
  // 👇 Esta key nos permite acceder al FormFieldState
  // final GlobalKey<FormFieldState<String>> _fieldKey = GlobalKey<FormFieldState<String>>();

  final Object _heroTag = Object();

  Future<void> _openOverlay() async {
    final result = await Navigator.of(context).push<_FloatResult>(
      PageRouteBuilder<_FloatResult>(
        opaque: false,
        barrierColor: Colors.black26,
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, anim, _) {
          return _FloatingEditorRoute(
            heroTag: _heroTag,
            controllerText: widget.controller.text,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            obscureText: widget.obscureText,
            fillColor: widget.fillColor,
            height: widget.height,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
          );
        },
        transitionsBuilder: (context, anim, _, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );

    if (result != null && result.accepted) {
      widget.controller.text = result.text;
      widget.controller.selection =
          TextSelection.collapsed(offset: result.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: _heroTag,
      flightShuttleBuilder: (ctx, anim, dir, fromCtx, toCtx) {
        return Material(
          type: MaterialType.transparency,
          child:
              dir == HeroFlightDirection.push ? fromCtx.widget : toCtx.widget,
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _openOverlay,
        child: ExcludeFocus(
            child: IsselTextFormField(
          // key: _fieldKey,              // 👈 usamos la key aquí
          controller: widget.controller,
          onTap: _openOverlay,
          height: widget.height,
          readOnly: true,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          fillColor: widget.fillColor,
          validator: widget.validator == null
              ? null
              : (_) => widget.validator!(widget.controller.text),
          obscureText: widget.obscureText,
        )),
      ),
    );
  }
}

class _FloatingEditorRoute extends StatefulWidget {
  final Object heroTag;
  final String controllerText;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Color? fillColor;
  final double height;
  final void Function(String value)? onChanged;
  final void Function(String)? onSubmitted;

  const _FloatingEditorRoute(
      {required this.heroTag,
      required this.controllerText,
      required this.hintText,
      required this.prefixIcon,
      required this.obscureText,
      required this.fillColor,
      required this.height,
      required this.onChanged,
      required this.onSubmitted});

  @override
  State<_FloatingEditorRoute> createState() => _FloatingEditorRouteState();
}

class _FloatingEditorRouteState extends State<_FloatingEditorRoute> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.controllerText);
  late final FocusNode _focusNode = FocusNode();
  bool _focusedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pide foco SOLO cuando la transición del route ha COMPLETADO (Hero listo)
    final anim = ModalRoute.of(context)?.animation;
    anim?.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_focusedOnce) {
        _focusedOnce = true;
        _focusNode.requestFocus(); // 👈 abre el teclado una sola vez
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Rect _availableRect(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final top = mq.viewPadding.top;
    final bottomInset = mq.viewInsets.bottom;
    final height = size.height - bottomInset - top;
    return Rect.fromLTWH(0, top, size.width, height);
  }

  double _targetWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return math.min(w - 32, 640);
  }

  @override
  Widget build(BuildContext context) {
    final avail = _availableRect(context);
    final fieldHeight = widget.height + 8;
    final targetW = _targetWidth(context);
    final left = (avail.width - targetW) / 2;
    final top = avail.top + (avail.height - fieldHeight) / 2;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(_FloatResult.cancel()),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            Positioned(
              top: top,
              left: left,
              width: targetW,
              height: widget.height + 20,
              child: Hero(
                tag: widget.heroTag,
                child: IsselTextFormField(
                  controller: _controller,
                  height: widget.height,
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  focusNode: _focusNode,
                  onSubmitted: (value) {
                    Navigator.of(context)
                        .pop(_FloatResult.ok(_controller.text));
                    widget.onSubmitted?.call(value);
                  },
                  obscureText: widget.obscureText,
                  readOnly: false,
                  onChanged: widget.onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatResult {
  final bool accepted;
  final String text;
  _FloatResult(this.accepted, this.text);
  factory _FloatResult.ok(String text) => _FloatResult(true, text);
  factory _FloatResult.cancel() => _FloatResult(false, '');
}
