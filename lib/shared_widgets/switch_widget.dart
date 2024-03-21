import 'package:flutter/material.dart';
import 'package:gti_rides/styles/styles.dart';

Widget switchWidget(context,
    {required bool value,
    required void Function(bool)? onChanged,
    Color? activeTrackColor}) {
  return Theme(
    data: Theme.of(context).copyWith(
        useMaterial3: false,
        colorScheme: const ColorScheme.dark(outline: Colors.transparent)),
    child: Switch(
      // thumb color (round icon)
      activeColor: primaryColor,
      activeTrackColor: activeTrackColor ?? borderColor.withOpacity(0.5),
      inactiveThumbColor: grey01,
      inactiveTrackColor: borderColor,
      splashRadius: 0.0,
      // boolean variable value
      value: value,
      // changes the state of the switch
      onChanged: onChanged,
    ),
  );
}
