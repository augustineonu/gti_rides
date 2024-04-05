import 'package:flutter/services.dart';
import 'package:gti_rides/services/logger.dart';
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

class DiscountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Filter non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Ensure input is within the range of 1 to 100
    int parsedValue = int.tryParse(newText) ?? 0;
    // if (parsedValue < 1) {
    //   parsedValue = 1;
    // } else 
    if (parsedValue > 100) {
      parsedValue = 100;
    }

      // Ensure the length of the input does not exceed 3 characters
    String formattedText = parsedValue.toString();
    if (formattedText.length > 3) {
      formattedText = formattedText.substring(0, 3);
    }
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}


class DNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Filter non-digit and non-decimal characters
    String newText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // If the input is empty, return an empty string
    if (newText.isEmpty) {
      return TextEditingValue.empty;
    }

    // If there's more than one decimal point, remove the extra ones
    if (newText.indexOf('.') != newText.lastIndexOf('.')) {
      newText = newText.substring(0, newText.lastIndexOf('.'));
    }

    // If a digit is entered after the decimal point, add the decimal point after the digit
    if (newText.endsWith('.') && newText.length > 1) {
      newText = newText.substring(0, newText.length - 1) + '.' + newText[newText.length - 1];
    }

    // Format the number with commas
    final formatter = NumberFormat("#,##0.0#", "en_US");
    String formattedText = formatter.format(double.parse(newText));

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}


// calculate price per day total fee
Future<double> calculateEstimatedTotal(
    String pricePerDay, int difference) async {
  Logger logger = Logger("CalculateEstimatedTotal");

  try {
    // Remove commas and parse the pricePerDay string to a double
    double price = double.parse(pricePerDay.replaceAll(',', ''));

    // Calculate the estimated total
    double estimatedTotal = price * difference;

    logger.log("Estimated total: ${estimatedTotal.toString()}");

    return estimatedTotal;
  } catch (e) {
    // Handle the case where the conversion fails
    logger.log("Error converting pricePerDay to double: $e");
    return 0.0; // or any default value
  }
}

// either i have to re-write this method to not always add.
// to be able to know when to subtract
Future<double> calculatePriceChangesDifference({
  String? total = '0',
  String? cautionFee = '0',
  String? pickUpFee = '0',
  String? dropOffFee = '0',
  // String? escortFee = '0',
}) async {
  Logger logger = Logger("calculatePriceChangesDifference");

  try {
    // Parse the fees to double
    double parsedCautionFee = double.parse(cautionFee!.replaceAll(',', ''));
    double parsedPickUpFee = double.parse(pickUpFee!.replaceAll(',', ''));
    double parsedDropOffFee = double.parse(dropOffFee!.replaceAll(',', ''));
    // double parsedEscortFee = double.parse(escortFee!.replaceAll(',', ''));
    double parsedTotal = double.parse(total!.replaceAll(',', ''));

    // Calculate the total by summing up the fees
    double estimatedTotal = parsedCautionFee +
        parsedPickUpFee +
        parsedDropOffFee +
        // parsedEscortFee +
        parsedTotal;

    logger.log("Estimated total: ${estimatedTotal.toString()}");

    return estimatedTotal;
  } catch (e) {
    // Handle the case where the conversion fails
    logger.log("Error calculating price changes difference: $e");
    return 0.0; // or any default value
  }
}

Future<double> calculateEscortFee(
    {String? escortFee,
    String? numberOfEscort,
    // String? initialEstimatedTotal
    }) async {
  Logger logger = Logger("calculateEscortFee");

  try {
    // Parse the escort fee to double
    double parsedEscortFee = double.parse(escortFee!.replaceAll(',', ''));
    int parsedEscortNumber = numberOfEscort != null && numberOfEscort.isNotEmpty
        ? int.parse(numberOfEscort.replaceAll(',', ''))
        : 1;
    // double parsedEstimatedTotal =
        // double.parse(initialEstimatedTotal!.replaceAll(',', ''));

    // Calculate the total escort fee
    double totalEscortFee = parsedEscortFee * parsedEscortNumber;

    logger.log("Total escort fee: ${totalEscortFee.toString()}");
    // var sumTotal = totalEscortFee + parsedEstimatedTotal;
    // logger.log("Total fee: ${sumTotal.toString()}");

    return totalEscortFee;
  } catch (e) {
    // Handle the case where the conversion fails
    logger.log("Error calculating escort fee: $e");
    return 0.0; // or any default value
  }
}

Future<String> formatAmount(double amount) async {
  Logger logger = Logger("Format amount");

  try {
    // Format the number with commas
    final formatter = NumberFormat("#,##0.0", "en_US");
    String formattedAmount = formatter.format(amount);
    logger.log("Formatted amount:: $formattedAmount");

    return formattedAmount;
  } catch (e) {
    // Handle formatting errors
    logger.log("Error formatting amount: $e");
    return "0.0"; // or any default value
  }
}

Future<double> calculateVAT(double estimatedTotal, String vatValue) async {
  Logger logger = Logger("Calculate VAT");

  try {
    // Parse the vatValue string to a double
    double vatPercentage = double.parse(vatValue);

    // Calculate the VAT amount
    double vatAmount = estimatedTotal * (vatPercentage / 100);
    vatAmount = double.parse(vatAmount.toStringAsFixed(3));

    logger.log("VAT amount: ${vatAmount.toString()}");

    return vatAmount;
  } catch (e) {
    // Handle the case where the conversion fails or other errors
    logger.log("Error calculating VAT: $e");
    return 0.0; // or any default value
  }
}
