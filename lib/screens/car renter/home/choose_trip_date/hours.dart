import 'package:flutter/material.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

class Hours extends StatelessWidget {
  const Hours({super.key, required this.hours, this.color, this.fontWeight});
  final int hours;
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
                text: hours.toString(),
                style: getLightStyle(
                  fontSize: 16,
                  color: color,
                ).copyWith(fontWeight: fontWeight)),
          ),
        ),
      ),
    );
  }
}
