import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/styles/styles.dart';

class BuildCarouselDot extends StatelessWidget {
  const BuildCarouselDot(
      {Key? key, required this.index, required this.currentIndex})
      : super(key: key);
  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.0.h,
      width: 6.0.w,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0.r),
        color: currentIndex == index ? white : grey1,
      ),
    );
  }
}
