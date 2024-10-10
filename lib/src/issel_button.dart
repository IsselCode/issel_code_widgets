import 'package:flutter/material.dart';
import 'issel_circular_progress_indicator.dart';

class IsselButton extends StatefulWidget {

  Future<void>? Function() onPressed;
  Future<void>? Function()? onLongPress;
  bool autofocus;
  String text;
  TextAlign? textAlign;
  TextStyle? textStyle;
  double width;
  double height;
  Color color;

  IsselButton({
    required this.onPressed,
    this.onLongPress,
    required this.text,
    this.autofocus = false,
    this.textAlign,
    this.textStyle,
    this.height = 50,
    this.width = 350,
    required this.color,

  });

  @override
  State<IsselButton> createState() => _IsselButtonState();

}

class _IsselButtonState extends State<IsselButton> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        isLoading = true;
        setState(() {});

        await widget.onPressed();

        isLoading = false;
        setState(() {});
      },
      onLongPress: widget.onLongPress != null ? () async {
        isLoading = true;
        setState(() {});

        await widget.onLongPress!();

        isLoading = false;
        setState(() {});
      } : null,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        backgroundColor: WidgetStateProperty.all(widget.color),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        elevation: WidgetStateProperty.all(0),
        fixedSize: WidgetStateProperty.all(Size(widget.width, widget.height))
      ),
      autofocus: widget.autofocus,
      child: isLoading
        ? IsselCircularProgressIndicator()
        : Text(
          widget.text,
          maxLines: 1,
          textAlign: widget.textAlign,
          style: widget.textStyle,
        ),
    );
  }
}