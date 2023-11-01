import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldLengthFormatter extends LengthLimitingTextInputFormatter {
  FieldLengthFormatter(int maxLength) : super(maxLength);

  ///Use as a class
  ///to set the maxLength for the field
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (maxLength != null && maxLength! > 0 && newValue.text.characters.length > maxLength!) {
      if (oldValue.text.characters.length == maxLength) {
        return oldValue;
      }
      // ignore: invalid_use_of_visible_for_testing_member
      return LengthLimitingTextInputFormatter.truncate(newValue, maxLength!);
    }
    return newValue;
  }
}
