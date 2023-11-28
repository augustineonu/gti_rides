import 'package:flutter/material.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

class AmPm extends StatelessWidget {
  const AmPm({super.key, required this.isItAm});
  final bool isItAm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ColoredBox(
        color: white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: textWidget(
                text: isItAm ? 'AM' : 'PM', style: getLightStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
