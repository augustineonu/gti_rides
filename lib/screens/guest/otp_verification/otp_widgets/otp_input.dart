import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:pinput/pinput.dart';

Widget buildOTPPinPut({
  required TextEditingController controller,
  required BuildContext context,
  required String otpType,
  String? email,
  String? phone,
  Function(String)? onCompleted,
  FocusNode? focusNode,
}) {
  // final theme = VoucherfastTheme.of(context);
  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    margin: const EdgeInsets.symmetric(horizontal: 3),
    textStyle: getBoldStyle(fontSize: 16),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: white,
        border: Border.all(color: grey1, width: 1.0.w)),
  );
  final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: grey1, width: 1.0.w),
    color: white,
  );

  return Pinput(
      // validator: (s) {
      //   return s == '2222' ? null : 'Pin is incorrect';
      // },
      focusNode: focusNode,
      length: 5,
      controller: controller,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
      showCursor: true,
      keyboardType: TextInputType.number,
      cursor: Text(
        "_",
        style: getMediumStyle(fontSize: 24.sp),
      ),
      useNativeKeyboard: true,
      onChanged: (pin) {
        print("pincode $pin");
      },
      onCompleted: onCompleted);
}