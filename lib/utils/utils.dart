import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../services/logger.dart';
import '../shared_widgets/shimmer_loading/shimmer_loading.dart';

String fetchErrorText({required String expectedTextVariable}) {
  switch (expectedTextVariable) {
    case "email":
      return AppStrings.emailIsRequiredError;
    case ".com":
      return AppStrings.emailIsRequiredError1;
    case "password":
      return AppStrings.passwordIsRequiredError;
    case 'phone':
      return AppStrings.phoneIsRequiredError;
    case 'phone length':
      return AppStrings.phoneLengthError;
    case 'otp':
      return AppStrings.otpIsRequiredError;
    case 'fullName':
      return AppStrings.fullNameRequiredError;
    case 'field':
      return AppStrings.fieldIsRequiredError;
    case 'gender':
      return AppStrings.selectGenderError;
    case 'bank':
      return AppStrings.selectBankError;
    case 'accountNumber':
      return AppStrings.selectAccountNumberError;
    case "valid phone number":
      return "Phone number is not valid";
    default:
      return AppStrings.isRequiredError;
  }
}

String displayTimeago(DateTime dateTime) {
  Locale? currentLocale = Get.deviceLocale;
  timeago.setLocaleMessages(currentLocale!.languageCode, timeago.EnMessages());
  String formattedTimeAgo =
      timeago.format(dateTime, locale: '${currentLocale.languageCode}_short');
  return formattedTimeAgo;
}

String getTimeIn12HourFormat(DateTime dateTime) {
  String formattedTime = DateFormat('h:mm a').format(dateTime);
  return formattedTime;
}

String formatDate(DateTime datetime) {
  var formatter = DateFormat('yyyy/MM/dd');
  return formatter.format(datetime);
}

// "dd, MMM h:mma"
String extractMonthDay(String dateString) {
  try {
    // Split the input string by whitespace
    List<String> parts = dateString.split(' ');

    // Combine the day of the week, day of the month, and month
    String formattedDate = '${parts[0]} ${parts[1]} ${parts[2]}';

    return formattedDate;
  } catch (e) {
    // Handle the exception or simply return an empty string
    return '';
  }
}

String extractTime(String dateString) {
  try {
    // Split the input string by whitespace
    List<String> parts = dateString.split(' ');

    // Combine the day of the week, day of the month, and month
    String formattedDate = parts[3];

    return formattedDate;
  } catch (e) {
    // Handle the exception or simply return an empty string
    return '';
  }
}

String extractDay(String inputDate) {
  // Split the input date by comma and space
  List<String> parts = inputDate.split(', ');

  // Extract the day part
  String day = parts[1].split(' ')[0];
  // Return the extracted day
  return day;
}

String extractDayMonth(String inputDate) {
  // Split the input date by comma and space
  List<String> parts = inputDate.split(', ');

  // Extract the day part
  String day = parts[1].split(' ')[0];
  String month = parts[1].split(' ')[1];

  // Return the extracted day
  return '$day $month';
}

String extractDayDateMonth(String inputDate) {
  // Split the input date by comma and space
  List<String> parts = inputDate.split(', ');

  // Extract the day and date parts
  String day = parts[0];
  String date = parts[1].split(' ')[0];
  String month = parts[1].split(' ')[1];

  // Return the day, date, and month
  return '$day, $date $month';
}

String formatDateTime1(String datetime) {
  // Remove the ordinal indicator ("th") from the day
  String cleanedDate =
      datetime.replaceAllMapped(RegExp(r'(\d+)(st|nd|rd|th)'), (match) {
    return match.group(1)!;
  });

  var formatter = DateFormat('dd, MMMM h:mma');
  DateTime parsedDate = formatter.parse(cleanedDate);
  String formattedDate = DateFormat('dd, MMM h:mma').format(parsedDate);
  return formattedDate;
}

String formatDateTime2(String datetime) {
  // Split the input string by spaces
  List<String> parts = datetime.split(' ');

  // Ensure that there are at least two parts (day and month)
  if (parts.length >= 2) {
    String day = parts[0];
    String monthAbbreviation = parts[1].substring(0, 3);

    // Join the day, comma, abbreviated month, and the rest of the string
    String formattedDate =
        '$day $monthAbbreviation ${parts.sublist(2).join(' ')}';

    return formattedDate;
  }

  // Return the original string if something goes wrong
  return datetime;
}

DateTime addHoursAndMinutes({
  required DateTime dateTime,
  required int hours,
  required int minutes,
  required bool isAM,
}) {
  int totalHours = hours;
  if (!isAM && dateTime.hour < 12) {
    totalHours += 12;
  }

  // DateTime result = dateTime.add(Duration(hours: totalHours, minutes: minutes));

  DateTime result = DateTime(
      dateTime.year, dateTime.month, dateTime.day, totalHours, minutes);

  print("Input DateTime: $dateTime");
  print("Added Hours: $totalHours");
  print("Added Minutes: $minutes");
  print("Result DateTime: $result");

  return result;
}

// rteurns date as example 1 Nov
String formatDateMonth(DateTime datetime) {
  var formatter = DateFormat('dd MMM');
  return formatter.format(datetime);
}

// rteurns date as example 1 Nov
String formatDateMonth1(String datetime) {
  if (datetime.isNotEmpty) {
    try {
      DateTime parsedDate = DateTime.parse(datetime);
      var formatter = DateFormat('dd MMM').format(parsedDate);
      return formatter;
    } catch (e) {
      // Handle the case where parsing fails
      print('Error parsing date: $e');
    }
  }

  // Return a default value or an empty string if the input is empty
  return 'N/A';
}

// / returns date as example Wed, 1 Nov
String formatDayDate(DateTime datetime) {
  var formatter = DateFormat('E, d MMM');
  return formatter.format(datetime);
}

// / returns date as example Wed, 1 Nov
String formatDayDate1(String datetime) {
  if (datetime.isNotEmpty) {
    try {
      DateTime parsedDate = DateTime.parse(datetime);
      var formatter = DateFormat('E, d MMM').format(parsedDate);
      return formatter;
    } catch (e) {
      // Handle the case where parsing fails
      print('Error parsing date: $e');
    }
  }

  // Return a default value or an empty string if the input is empty
  return 'N/A';
}

// returns as 9:00am
String formatTime1(String time) {
  if (time.isNotEmpty) {
    try {
      DateTime parsedDate = DateTime.parse(time);
      var formatter = DateFormat('h:mm a').format(parsedDate);
      return formatter;
    } catch (e) {
      print("unable to format time $e");
      return time;
    }
  }
  return 'N/A';
}

// returns as 9:00am
String formatTime(DateTime time) {
  try {
    var formatter = DateFormat('h:mm a');
    return formatter.format(time);
  } catch (e) {
    print("unable to format time $e");
    return time.toIso8601String();
  }
}

String formatDateTimeOrTime(DateTime dateTime) {
  final now = DateTime.now();
  final dateFormat = DateFormat('MMM d, y');
  final timeFormat = DateFormat('h:mm a');

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return timeFormat.format(dateTime);
  } else {
    return '${dateFormat.format(dateTime)} ${timeFormat.format(dateTime)}';
  }
}

// wed, 1 Nov, 9:00am
String formateDate({required String date}) {
  try {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('E, d MMM, h:mma').format(dateTime);
    return formattedDate;
  } catch (e) {
    // Return the original string if parsing fails
    return date;
  }
}

//// wed, 1 Nov, 9:00am
String isSingleDateSelection({required DateTime date}) {
  try {
    // DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('E, d MMM, h:mma').format(date);
    return formattedDate;
  } catch (e) {
    // Return the original string if parsing fails
    return 'NAN';
  }
}

String formatRelativeDateTime({required DateTime date, bool relative = false}) {
  try {
    if (relative) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      if (date.isAtSameMomentAs(today)) {
        return 'Today ' + DateFormat('h:mma').format(date);
      } else if (date.isAtSameMomentAs(yesterday)) {
        return 'Yesterday ' + DateFormat('h:mma').format(date);
      } else if (date.isAfter(yesterday)) {
        return DateFormat('E, d MMM, h:mma').format(date);
      } else {
        return DateFormat('E, d MMM, yyyy, h:mma').format(date);
      }
    } else {
      // Format the date in the default way
      String formattedDate = DateFormat('E, d MMM, h:mma').format(date);
      return formattedDate;
    }
  } catch (e) {
    // Return the original string if parsing fails
    return 'NAN';
  }
}
bool isDateAfterCarAvailability(
      {required DateTime rawEndTime,
      required DateTime carAvailabilityEndDate}) {
    return rawEndTime.isAfter(carAvailabilityEndDate);
  }

// String isSingleDateSelection({required DateTime date, bool relative = false}) {
//   try {
//     if (relative) {
//       // Format the date to be relative
//       final Duration difference = DateTime.now().difference(date);
//       if (difference.inDays > 0) {
//         return '${difference.inDays} days ago';
//       } else if (difference.inHours > 0) {
//         return '${difference.inHours} hours ago';
//       } else if (difference.inMinutes > 0) {
//         return '${difference.inMinutes} minutes ago';
//       } else {
//         return 'Just now';
//       }
//     } else {
//       // Format the date in the default way
//       String formattedDate = DateFormat('E, d MMM, h:mma').format(date);
//       return formattedDate;
//     }
//   } catch (e) {
//     // Return the original string if parsing fails
//     return 'NAN';
//   }
// }

// 7 Mar, 1:16PM
String formatDateTime01({required DateTime date}) {
  try {
    // DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('d MMM, h:mma').format(date);
    return formattedDate;
  } catch (e) {
    // Return the original string if parsing fails
    return 'NAN';
  }
}

String formatDateTime(String datetime) {
  var formatter = DateFormat('dd, MMMM h:mma');
  DateTime parsedDate = formatter.parse(datetime);
  String formattedDate = DateFormat('dd, MMM h:mma').format(parsedDate);
  return formattedDate;
}

DateTime? parseDateTime(String datetime) {
  try {
    var formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    DateTime parsedDate = formatter.parse(datetime);
    return parsedDate;
  } catch (e) {
    Logger('Utils').log("Error parsing datetime: $e");
    return null;
  }
}

// 02 - 05 - 2013
String formatDate1({required String date}) {
  try {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd - MM - yyyy').format(dateTime);
    return formattedDate;
  } catch (e) {
    // Return the original string if parsing fails
    return date;
  }
}

String formatDateTimeOrTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final timeFormat = DateFormat('h:mm a');
  final dateFormat = DateFormat('d/M/yyyy');
  // final dateFormat = DateFormat('MMM d, y');

  if (dateTime.isAfter(now.subtract(Duration(days: 7)))) {
    Locale? currentLocale = Get.deviceLocale;
    timeago.setLocaleMessages(
        currentLocale!.languageCode, timeago.EnMessages());
    return '${dateFormat.format(dateTime)}';
    // return timeago.format(dateTime,
    //     allowFromNow: true, locale: '${currentLocale.languageCode}_short');
  } else {
    return '${dateFormat.format(dateTime)}';
    // return '${dateFormat.format(dateTime)} \n${timeFormat.format(dateTime)}';
  }
}

// the method is explanatory
bool isUserAbove21(DateTime selectedDateOfBirth) {
  // Calculate today's date
  DateTime today = DateTime.now();

  // Calculate the age by subtracting the selected date of birth from today's date
  int age = today.year - selectedDateOfBirth.year;

  // Check if the birthday has occurred this year or not
  if (today.month < selectedDateOfBirth.month ||
      (today.month == selectedDateOfBirth.month &&
          today.day < selectedDateOfBirth.day)) {
    age--;
  }

  // Check if the age is greater than or equal to 21
  return age >= 21;
}

showErrorSnackbar({required String message, Color? color}) {
  final overlayContext = Get.overlayContext;
  if (overlayContext != null) {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      message: message,
      isDismissible: false,
      backgroundColor: color ?? danger,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      borderRadius: 16.0,
      mainButton: GestureDetector(
        onTap: () => routeService.goBack(),
        child: const Icon(
          CupertinoIcons.clear_circled,
          color: white,
        ),
      ),
    );
  } else {
    Logger('Utils').log("overlay context is null");
  }
}

showSuccessSnackbar(
    {required String message,
    String? title,
    Color? color,
    Color? textColor,
    int? seconds}) {
  final overlayContext = Get.overlayContext;
  if (overlayContext != null) {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      title: title,
      message: message,
      isDismissible: false,
      backgroundColor: color ?? success,
      duration: Duration(seconds: seconds ?? 3),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      borderRadius: 16.0,
      mainButton: GestureDetector(
        onTap: () => routeService.goBack(),
        child: const Icon(
          CupertinoIcons.clear_circled,
          color: white,
        ),
      ),
    );
  } else {
    Logger('Utils').log("overlay context is null");
  }
}

Object bottomSnackbar(BuildContext context, {required String message}) {
  final overlayContext = Get.overlayContext;
  if (overlayContext != null) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: primaryColor,
      content: Text(
        message,
      ),
      duration: Duration(milliseconds: 800),
    ));
  } else {
    Logger('Utils').log("overlay context is null");
    return SizedBox();
  }
}

/**
 * Custom Alert Dialog
 */
Future<void> showCustomDialog({
  bool barrierDismissible = true,
  String cancelBtnText = 'Cancel',
  String okBtnText = "Let's go",
  String? singleBtnText,
  String? title,
  Color? titleColor,
  Color? messageColor,
  Color? cancelColor,
  Color? okColor,
  String? message,
  Function? onOkPressed,
  Function? singleBtnPressed,
}) async {
  await Get.dialog(
    AlertDialog(
      // backgroundColor: whiteOrBlackColor(),
      // icon: SvgPicture.asset(ImageAssets.featuredIcon),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        message ?? '',
        // style:
        //     getBoldStyle(color: messageColor ?? textColor(), fontSize: 14.sp),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: singleBtnText != null
          ? <Widget>[
              GtiButton(
                height: 40.h,
                width: 150.w,
                onTap: () async {
                  await singleBtnPressed!();
                },
                // color: okColor ?? calm,
                borderRadius: 8,
                text: singleBtnText,
              ),
            ]
          : <Widget>[
              GtiButton(
                width: 100.w,
                height: 40.h,
                onTap: () => Get.back(),
                color: cancelColor ?? danger,
                borderRadius: 8,
                text: cancelBtnText,
              ),
              GtiButton(
                width: 100.w,
                height: 40.h,
                onTap: () => onOkPressed!(),
                // color: okColor ?? calm,
                borderRadius: 8,
                text: okBtnText,
              ),
            ],
    ),
    barrierDismissible: barrierDismissible,
  );
}

Widget showShimmerLoader() {
  return ListView.separated(
    itemCount: 5,
    itemBuilder: (context, index) => ShimmerLoading(),
    separatorBuilder: (context, index) => const SizedBox(height: 10),
  );
}

// https://www.gtiautos.com/
void openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    Logger('Utils').debug('msg: Failed to launch $url');
  }
}
