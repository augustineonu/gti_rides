import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

Widget dateContainer(
  Size size, {
  void Function()? onTap,
  required String text,
  required String title,
  Color? color,
  AlignmentGeometry? alignment,
  bool? isCentered = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      textWidget(
          text: title,
          textOverflow: TextOverflow.visible,
          style: getRegularStyle(fontSize: 14)),
      SizedBox(
        height: 3,
      ),
      GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: alignment,
          height: 45.h,
          width: size.width,
          constraints:
              BoxConstraints.tightFor(width: size.width.sp, height: 45.sp),
          // width: size.width,
          margin: EdgeInsets.symmetric(vertical: 5.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(4.r),
            ),
            border: Border.all(color: grey1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
            child: isCentered!
                ? textWidget(
                    text: text,
                    style: getRegularStyle(fontSize: 12.sp, color: color))
                : Center(
                  child: textWidget(
                      text: text,
                      style: getRegularStyle(fontSize: 12.sp, color: color)),
                ),
          ),
        ),
      ),
    ],
  );
}
