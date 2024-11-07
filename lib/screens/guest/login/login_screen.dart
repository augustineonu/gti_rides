import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/guest/login/login_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/password_input_text_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }
}

class LoginScreen extends GetView<LoginController> {
  LoginScreen({super.key});
  @override
  final controller = Get.put<LoginController>(LoginController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              child: body(context, width),
            ),
            controller.isLoading1.isTrue
                ? Stack(
                    children: [
                      const Opacity(
                        opacity: 0.5,
                        child: ModalBarrier(
                            dismissible: false, color: Colors.black),
                      ),
                      Center(
                        child: Center(
                          child: centerLoadingIcon(),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
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
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: controller.loginFormKey,
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
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(45),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return fetchErrorText(expectedTextVariable: "field");
                        }
                        if (value.contains('@')) {
                          // Check if the input contains '@', indicating it might be an email
                          if (!controller.isValidEmail(value)) {
                            return fetchErrorText(expectedTextVariable: '.com');
                          }
                        } else {
                          // Check if the input is a valid phone number
                          if (!controller.isValidPhoneNumber(value)) {
                            return fetchErrorText(
                                expectedTextVariable: 'valid phone number');
                          }
                        }
                        // if (!value.contains('.com')) {
                        //   return fetchErrorText(expectedTextVariable: '.com');
                        // }
                        return null;
                      },
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
                        validator: (password) {
                          if (password!.isEmpty) {
                            return fetchErrorText(
                                expectedTextVariable: "password");
                          }
                          // Password should be at least 8 characters long
                          if (password.length < 8) {
                            return "Password must be at least 8 characters long";
                          }

                          // Password should contain at least one uppercase letter, one lowercase letter, one number, and one special character
                          final RegExp passwordRegex = RegExp(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
                          if (!passwordRegex.hasMatch(password)) {
                            return "Password should contain at least one uppercase letter, one lowercase letter, one number, and one special character";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 14.sp,
                    ),
                    forgotPassword(
                        onTap: controller.routeToRequestRestePassword),
                    SizedBox(
                      height: 40.sp,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GtiButton(
                          text: "Continue as a Guest",
                          width: width,
                          textColor: primaryColor,
                          hasBorder: true,
                          borderColor: primaryColor,
                          color: white,
                          onTap: controller.routeToRenterLanding,
                        ),

                        SizedBox(
                          height: 10.sp,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              controller.routeToRenterLanding();
                            },
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.r)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: textWidget(
                                  text: "Or", style: getMediumStyle()),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),

                        controller.isLoading.value
                            ? centerLoadingIcon()
                            : GtiButton(
                                text: AppStrings.loginButtonText,
                                width: width,
                                onTap: controller.processLogin,
                              ),

                        // Center(
                        //   child: InkWell(
                        //     onTap: () {
                        //       controller.routeToRenterLanding();
                        //     },
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(6.r)),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(6.0),
                        //       child: textWidget(
                        //           text: "Continue as a Guest",
                        //           style: getMediumStyle()),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        signUp(onTap: () => controller.routeToSignUp()),
                        SizedBox(
                          height: 36.sp,
                        ),
                        touchID(onTap: () {
                          controller.biometricLogin();
                        }),
                      ],
                    ),
                  ],
                ),
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
