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
    case "password":
      return AppStrings.passwordIsRequiredError;
    case 'phone':
      return AppStrings.phoneIsRequiredError;
    case 'otp':
      return AppStrings.otpIsRequiredError;
    case 'fullName':
      return AppStrings.fullNameRequiredError;
    case 'field':
      return AppStrings.fieldIsRequiredError;
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

// String formatDate(DateTime datetime) {
//   // var formatter = DateFormat('yyyy-MM-dd');
//   var formatter = DateFormat('dd MMM yyyy');
//   return formatter.format(datetime);
// }

// rteurns date as example Wed, 1 Nove
String formatDate(DateTime datetime) {
  var formatter = DateFormat('dd MMM');
  return formatter.format(datetime);
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

showErrorSnackbar({required String message, Color? color}) {
  final overlayContext = Get.overlayContext;
  if (overlayContext != null) {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      message: message,
      isDismissible: false,
      backgroundColor: color ?? danger,
      duration: const Duration(seconds: 4),
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

showSuccessSnackbar({required String message, Color? color, Color? textColor}) {
  final overlayContext = Get.overlayContext;
  if (overlayContext != null) {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      message: message,
      isDismissible: false,
      backgroundColor: color ?? success,
      duration: const Duration(seconds: 4),
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

void openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    Logger('Utils').debug('msg: Failed to launch $url');
  }
}
