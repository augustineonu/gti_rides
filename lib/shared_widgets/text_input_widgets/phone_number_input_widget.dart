import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gti_rides/styles/styles.dart';

class PhoneNumberInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Icon? textInputIcon;
  final String labelText;
  final String expectedVariable;
  final TextInputType? textInputType;
  final Function onGestureTab;
  // final String dialedCode;
  final Widget? prefixIcon;
  final Widget? prefix;
  final void Function(String)? onChanged;

  const PhoneNumberInputWidget(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.expectedVariable,
      this.textInputType,
      this.textInputIcon,
      required this.onGestureTab,
      // required this.dialedCode,
      this.prefixIcon,
      this.prefix,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16.0),
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: prefixIcon ?? const Icon(IconlyBold.call),
        label: Text(
          labelText,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        prefix: prefix ?? SizedBox()
            // GestureDetector(
            //   onTap: onGestureTab(),
            //   child: Container(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            //     margin: const EdgeInsets.symmetric(horizontal: 8.0),
            //     decoration: const BoxDecoration(
            //         borderRadius: BorderRadius.all(Radius.circular(5.0))),
            //     child: Text('dialedCode',
            //         style: const TextStyle(color: primaryColor)),
            //   ),
            // ),
      ),
    );
  }
}
