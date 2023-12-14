import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/guest/otp_verification/otp_widgets/otp_input.dart';
import 'package:gti_rides/screens/shared_screens/more/account_details/account_verification/change_password/change_password_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ChangePasswordOtpScreen extends GetView<ChangePhoneController> {
  const ChangePasswordOtpScreen([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final controller = Get.put<ChangePhoneController>(ChangePhoneController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: appbar(),
      body: body(context, size),
    );
  }

  Widget body(BuildContext context, Size size) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                  text: AppStrings.verifyPhoneNumber,
                  textOverflow: TextOverflow.visible,
                  style: getBoldStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: black)
                      .copyWith(
                    fontFamily: "Neue",
                  ),
                ),
                SizedBox(
                  height: 8.sp,
                ),
                textWidget(
                  text:
                      AppStrings.pleaseInputOtpPhone.trArgs([controller.phone]),
                  textOverflow: TextOverflow.visible,
                  style: getLightStyle(fontSize: 12.sp, color: grey2)
                      .copyWith(fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 40.sp,
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: controller.otpFormKey,
                  child: buildOTPPinPut(
                    controller: controller.pinController,
                    context: context,
                    expectedVariable: 'otp',
                    focusNode: controller.focus,
                    onChanged: (pin) =>
                        controller.isDoneIputtingPin.value = pin.length == 6,
                    onCompleted: (pin) => pin.length == 6
                        ? controller.isDoneIputtingPin.value = true
                        : controller.isDoneIputtingPin.value = false,
                  ),
                ),
                SizedBox(
                  height: 30.sp,
                ),
                clickToResendCode(),
                SizedBox(height: size.height * 0.04),
                continueButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar appbar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Icon(
        Icons.arrow_back_rounded,
        color: black,
        size: 24.sp,
      ),
      title: SizedBox(),
    );
  }

  Widget clickToResendCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            if (controller.isCountDownFinished.value) {
              controller.resendOtp(emailOrPhone: controller.phone);
            } else {}
          },
          child: RichText(
            text: TextSpan(children: <InlineSpan>[
              TextSpan(
                  text: AppStrings.resendOtp,
                  style: getRegularStyle(color: primaryColor)),
              TextSpan(
                  text: controller.countdownText.value,
                  style: getRegularStyle(color: greyShade1)
                      .copyWith(fontWeight: FontWeight.w500)),
            ]),
          ),
        ),
      ],
    );
  }

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 45.sp,
            width: 300.sp,
            text: AppStrings.cont,
            textColor: controller.isDoneIputtingPin.value
                ? white
                : black.withOpacity(0.3),
            color: controller.isDoneIputtingPin.value
                ? primaryColor
                : primaryColorLight1,
            onTap: !controller.isDoneIputtingPin.value
                ? () {}
                : () => controller.verifyOtp(
                    emailOrPhone: controller.phone,
                    otp: controller.pinController.text),
            isLoading: controller.isLoading.value,
          );
  }
}
