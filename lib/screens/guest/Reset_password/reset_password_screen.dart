import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/guest/Reset_password/reset_password_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/password_input_text_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ResetPasswordController>(ResetPasswordController());
  }
}

TextEditingController textController = TextEditingController();

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: appbar(),
        body: body(context, size),
      ),
      // }
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
                  text: AppStrings.resetPassword,
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
                  height: 16.sp,
                ),
                PasswordInputTextWidget(
                  title: AppStrings.newPassword,
                  controller: controller.passwordController,
                  expectedVariable: 'password',
                  isObscureValue: controller.showPassword.value,
                  onTap: () => controller.obscurePassword(),
                ),
                SizedBox(
                  height: 16.sp,
                ),
                PasswordInputTextWidget(
                  title: AppStrings.confirmPassword,
                  controller: controller.conFirmPasswordController,
                  expectedVariable: 'password',
                  isObscureValue: controller.showPassword.value,
                  onTap: () => controller.obscurePassword1(),
                ),
                SizedBox(height: size.height * 0.08),
                ContinueButton(),
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(ImageAssets.authImage)),
      ],
    );
  }

  AppBar appbar() {
    return gtiAppBar(
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
          onPressed: () {},
          child: RichText(
            text: TextSpan(children: <InlineSpan>[
              TextSpan(
                  text: AppStrings.resendOtp,
                  style: getRegularStyle(color: primaryColor)),
              TextSpan(
                  text: "00:00",
                  style: getRegularStyle(color: greyShade1)
                      .copyWith(fontWeight: FontWeight.w500)),
            ]),
          ),
        ),
      ],
    );
  }

  Widget appLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(
              text: "Welcome",
              style: getBoldStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: iconColor()),
            ),
            SizedBox(
              height: 8.h,
            ),
            textWidget(
              text: "Login to continue",
              style: getBoldStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: iconColor()),
            ),
          ],
        ),
        // SvgPicture.asset(ImageAssets.appLogo),
      ],
    );
  }

  Widget ContinueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 45.sp,
            width: 300.sp,
            text: AppStrings.cont,
            color: primaryColor,
            onTap: () {},
            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }
}