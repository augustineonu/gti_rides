 import 'package:flutter/services.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied);
  }

    String extractFirstName(String fullName) {
    List<String> nameParts = fullName.split(' ');
    // If there is at least one part, return the first part (first name)
    return nameParts.isNotEmpty ? nameParts.first : '';
  }