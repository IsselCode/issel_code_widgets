
import 'package:flutter/services.dart';

class IsselInputFormatter{
  static TextInputFormatter int = TextInputFormatter.withFunction((oldValue, newValue) => RegExp(r'^(-?\d{0,10})?$').hasMatch(newValue.text) ? newValue : oldValue);
  static TextInputFormatter double = TextInputFormatter.withFunction((oldValue, newValue) => RegExp(r'^(-?\d{0,10}(?:\.\d{0,3})?)?$').hasMatch(newValue.text) ? newValue : oldValue);
  static TextInputFormatter textWithSpacing = TextInputFormatter.withFunction((oldValue, newValue) => RegExp(r'^([a-zA-Z]+[a-zA-Z ]*)?$').hasMatch(newValue.text) ? newValue : oldValue);
  static TextInputFormatter textWithSpacingWithNumbers = TextInputFormatter.withFunction((oldValue, newValue) => RegExp(r'^([a-zA-Z0-9\s]+)?$').hasMatch(newValue.text) ? newValue : oldValue);
  static TextInputFormatter textWithNumbers = TextInputFormatter.withFunction((oldValue, newValue) => RegExp(r'^([a-zA-Z0-9]+[a-zA-Z0-9]*)?$').hasMatch(newValue.text) ? newValue : oldValue);
  static TextInputFormatter textWithSpacingWithComma = TextInputFormatter.withFunction((oldValue, newValue) => RegExp(r'^[a-zA-Z,\s]*?').hasMatch(newValue.text) ? newValue : oldValue);
  static TextInputFormatter cellPhoneNumber = TextInputFormatter.withFunction((oldValue, newValue) => RegExp(r'^\d{0,10}$').hasMatch(newValue.text) ? newValue : oldValue);
  static TextInputFormatter email = TextInputFormatter.withFunction((oldValue, newValue) => RegExp(r'^[a-zA-Z0-9_.+-]*?@?[a-zA-Z0-9-]*?.?[a-zA-Z0-9-.]*?$').hasMatch(newValue.text) ? newValue : oldValue);
}