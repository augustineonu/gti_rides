import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

class AmPm extends StatelessWidget {
  const AmPm({super.key, required this.isItAm, this.color, this.fontWeight});
  final bool isItAm;
    final Color? color;
      final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ColoredBox(
        color: white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: textWidget(
                text: isItAm ? 'AM' : 'PM', style: getLightStyle(fontSize: 16.sp,
                color: color).copyWith(fontWeight: fontWeight)),
          ),
        ),
      ),
    );
  }
}
