import 'package:flutter/material.dart';

import 'issel_circular_progress_indicator.dart';

class IsselIconButton extends StatefulWidget {
  final Future<void>? Function() onPressed;
  final Future<void>? Function()? onLongPress;
  final bool autofocus;
  final IconData icon;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final double size;
  final Color color;
  final OutlinedBorder shape;

  // Constructor para botón circular
  const IsselIconButton.circular({
    super.key,
    required this.onPressed,
    this.onLongPress,
    required this.icon,
    this.autofocus = false,
    this.textAlign,
    this.textStyle,
    this.size = 50,
    required this.color,
  }) : shape = const CircleBorder();

  // Constructor para botón con borde redondeado
  IsselIconButton.roundedRectangle({
    super.key,
    required this.onPressed,
    this.onLongPress,
    required this.icon,
    this.autofocus = false,
    this.textAlign,
    this.textStyle,
    this.size = 50,
    required this.color,
    required double radius,
  }) : shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );

  @override
  _IsselIconButtonState createState() => _IsselIconButtonState();
}

class _IsselIconButtonState extends State<IsselIconButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });

        await widget.onPressed();

        setState(() {
          isLoading = false;
        });
      },
      onLongPress: widget.onLongPress != null
          ? () async {
        setState(() {
          isLoading = true;
        });

        await widget.onLongPress!();

        setState(() {
          isLoading = false;
        });
      }
          : null,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(widget.shape),
        backgroundColor: WidgetStateProperty.all(widget.color),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        elevation: WidgetStateProperty.all(0),
        fixedSize: WidgetStateProperty.all(Size(widget.size, widget.size)),
      ),
      autofocus: widget.autofocus,
      child: isLoading
        ? IsselCircularProgressIndicator()
        : Icon(widget.icon)
    );
  }
}