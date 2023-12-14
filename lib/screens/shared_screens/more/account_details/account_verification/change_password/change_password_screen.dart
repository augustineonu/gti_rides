import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/account_details/account_verification/acount_verification_controller.dart';
import 'package:gti_rides/screens/shared_screens/more/account_details/account_verification/change_password/change_password_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/password_input_text_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ChangePasswordScreen extends GetView<ChangePhoneController> {
  const ChangePasswordScreen([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put(ChangePhoneController());

    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: appbar(),
        body: body(context, size, controller: controller),
      ),
      // }
    );
  }

  Widget body(BuildContext context, Size size, {required ChangePhoneController controller}) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 16.sp),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
            key: controller.passwordInputFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PasswordInputTextWidget(
                    title: AppStrings.oldPasswordSm,
                    controller: controller.oldPasswordController,
                    expectedVariable: 'password',
                    isObscureValue: controller.showOldPassword.value,
                    onTap: () => controller.obscureOldPassword(),
                  ),
                  SizedBox(
                    height: 16.sp,
                  ),
                  PasswordInputTextWidget(
                    title: AppStrings.newPasswordSm,
                    controller: controller.newPasswordController,
                    expectedVariable: 'password',
                    isObscureValue: controller.showNewPassword.value,
                    onTap: () => controller.obscureNewPassword(),
                  ),
                  SizedBox(
                    height: 16.sp,
                  ),
                  PasswordInputTextWidget(
                    title: AppStrings.confirmPasswordSm,
                    controller: controller.confirmPasswordController,
                    expectedVariable: 'password',
                    isObscureValue: controller.showConfirmPassword.value,
                    onTap: () => controller.obscureConfirmPassword(),
                  ),
                  SizedBox(height: size.height * 0.08),
                  ContinueButton(),
                ],
              ),
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
      title: textWidget(
          text: AppStrings.password,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
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
            text: AppStrings.resetPassword,
            color: primaryColor,
            onTap: controller.sendOtp,
            isLoading: controller.isLoading.value,
          );
  }
}
