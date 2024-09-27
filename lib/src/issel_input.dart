import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IsselTextField extends StatefulWidget {

  String hintText;
  String label;
  TextEditingController controller;
  IconData? icon;
  bool obscureText;
  bool white;
  bool autofocus;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  void Function(String value)? onFieldSubmitted;
  Color fillColor;
  Color focusBorderColor;
  Color iconUnfocusedColor;


  IsselTextField({
    super.key,
    this.autofocus = false,
    required this.hintText,
    this.white = true,
    this.icon,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.inputFormatters,
    required this.fillColor,
    required this.focusBorderColor,
    required this.iconUnfocusedColor,
    this.keyboardType,
    this.onFieldSubmitted
  });

  @override
  State<IsselTextField> createState() => _InputApp2State();
}

class _InputApp2State extends State<IsselTextField> {

  late bool obscureText;

  @override
  void initState() {
    obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      inputFormatters: widget.inputFormatters,
      style: Theme.of(context).textTheme.bodySmall,
      textAlignVertical: TextAlignVertical.center,
      obscureText: obscureText,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
          constraints: const BoxConstraints(
              maxWidth: 350
          ),
          alignLabelWithHint: false,
          label: Text(widget.label, style: Theme.of(context).textTheme.bodySmall,),
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          hintText: widget.hintText,
          prefixIcon: widget.icon != null ? Icon(widget.icon, size: 20,) : null,
          isCollapsed: false,
          filled: true,
          fillColor: widget.fillColor,
          suffixIcon: widget.obscureText ? _iconButton() : null,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: widget.focusBorderColor
              )
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
          )
      ),
    );
  }

  IconButton _iconButton(){
    return IconButton(
      icon: Icon(Icons.remove_red_eye_outlined, color: !obscureText ? widget.focusBorderColor : widget.iconUnfocusedColor),
      onPressed: () {
        obscureText = !obscureText;
        setState(() {});
      },
    );
  }

}
