import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

Widget carAvailabilityTag({
  required String status,
  double? positionRight,
  double? positionTop,
  double? positionLeft,
}) {
  return Positioned(
    right: positionRight,
    top: positionTop,
    left: positionLeft,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.all(
          Radius.circular(2.r),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(2.r),
            ),
            border: Border.all(
              color: primaryColor,
            )),
        child: Center(
          child: textWidget(
            text: status,
            style: getLightStyle(fontSize: 10.sp, color: primaryColor)
                .copyWith(fontWeight: FontWeight.w300),
          ),
        ),
      ),
    ),
  );
}
