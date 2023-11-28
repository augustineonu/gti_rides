import 'package:flutter/material.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

class Minutes extends StatelessWidget {
  const Minutes({super.key, required this.mins});
  final int mins;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ColoredBox(
        color: white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:5.0),
            child: textWidget(text: mins < 10 ? '0$mins' : mins.toString(), style: getLightStyle(
              fontSize: 16
            )),
          ),
        ),
      ),
    );
  }
}
