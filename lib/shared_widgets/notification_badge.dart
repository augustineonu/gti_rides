import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

Widget notificationBadge({required int totalNotifications}) {
  return Positioned(
    bottom: 10,
    right: 6,
    child: Container(
      height: 22.h,
      width: 20.w,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: textWidget(
              text: '$totalNotifications',
              style: getSemiBoldStyle(fontSize: 12, color: black),
              textAlign: TextAlign.center),
        ),
      ),
    ),
  );
}
