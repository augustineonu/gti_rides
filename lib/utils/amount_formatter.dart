import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Filter non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

       // If the input is empty, return an empty string
    if (newText.isEmpty) {
      return TextEditingValue.empty;
    }

    // Format the number with commas
    final formatter = NumberFormat("#,##0", "en_US");
    String formattedText = formatter.format(int.parse(newText));

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}