 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

Widget tabIndicator(
      {required String title, required bool selected, void Function()? onTap,
      double? width
      }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: width,
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 16.sp),
        decoration: BoxDecoration(
            color: selected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(4.r))),
        child: Center(
          child: textWidget(
              text: title,
              style: getRegularStyle(color: selected ? white : grey3)),
        ),
      ),
    );
  }