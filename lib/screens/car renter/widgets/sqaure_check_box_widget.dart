import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget sqaureCheckBox(
    {BoxBorder? border,
    Color? color,
    double? marginRight,
    double? padingWidth}) {
  return AnimatedContainer(
    height: 14.sp,
    width: 14.sp,
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.only(right: marginRight ?? 10.sp),
      padding: EdgeInsets.all(padingWidth ?? 3.sp),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(2.r),
        border: border,
      ),
      child: Container(padding: EdgeInsets.all(3.sp), color: color));
}
