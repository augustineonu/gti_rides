import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/guest/login/login_controller.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/password_input_text_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }
}

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Stack(
          children: [
            SafeArea(child: body(context, width)),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: SvgPicture.asset(ImageAssets.authImage)),
          ],
        ),
      ),
    );
  }

  Widget body(BuildContext context, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                      text: AppStrings.welcome,
                      style: getBoldStyle(fontSize: 24.sp).copyWith(
                          fontFamily: "Neue", fontWeight: FontWeight.w500)),
                  textWidget(
                      text: AppStrings.inputYourDetailsLogin,
                      style: getLightStyle(fontSize: 12.sp, color: grey2)
                          .copyWith(fontWeight: FontWeight.w300)),
                  SizedBox(
                    height: 22.sp,
                  ),
                  NormalInputTextWidget(
                    title: AppStrings.emailOrPhone,
                    expectedVariable: "email",
                    hintText: AppStrings.emailHintText,
                    controller: controller.emailOrPhoneController,
                  ),
                  SizedBox(
                    height: 16.sp,
                  ),
                  PasswordInputTextWidget(
                    title: AppStrings.password,
                    controller: controller.passwordController,
                    expectedVariable: 'password',
                    isObscureValue: controller.showPassword.value,
                    onTap: () => controller.obscurePassword(),
                  ),
                  SizedBox(
                    height: 14.sp,
                  ),
                  forgotPassword(onTap: () {}),
                  SizedBox(
                    height: 40.sp,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GtiButton(
                        text: AppStrings.loginButtonText,
                        width: width,
                        onTap: () => controller.routeToLandingPage(),
                      ),
                      SizedBox(
                        height: 22.sp,
                      ),
                      signUp(onTap: () => controller.routeToSignUp()),
                      SizedBox(
                        height: 36.sp,
                      ),
                      touchID(onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget forgotPassword({void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          textWidget(
              text: AppStrings.forgotPassword,
              style: getRegularStyle(color: primaryColor).copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: primaryColor)),
        ],
      ),
    );
  }

  Widget signUp({void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          text: "${AppStrings.dontHaveAccount} ",
          style: getRegularStyle(color: grey2)
              .copyWith(fontWeight: FontWeight.w500),
          children: <TextSpan>[
            TextSpan(
              text: AppStrings.signUp,
              style: getRegularStyle().copyWith(fontWeight: FontWeight.w400),
            ),
            // can add more TextSpans here...
          ],
        ),
      ),
    );
  }

  Widget touchID({Function()? onTap}) {
    return GestureDetector(
        onTap: onTap, child: SvgPicture.asset(ImageAssets.touchID));
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(ImageAssets.appLogoRide),
        InkWell(
          onTap: () {
            // controller.routeToLogin();
          },
          child: textWidget(
              text: "skip_to_login".tr,
              style: getMediumStyle(color: primaryColor)),
        ),
      ],
    );
  }
}