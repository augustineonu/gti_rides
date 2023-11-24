import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:iconsax/iconsax.dart';

Widget backButtonCircled({required void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40.h,
      width: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: iconColor()),
      ),
      child: Center(
          child: Icon(
        Iconsax.arrow_left,
        size: 20.sp,
        color: iconColor(),
      )),
    ),
  );
}
