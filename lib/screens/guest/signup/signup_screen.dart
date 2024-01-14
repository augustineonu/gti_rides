import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/guest/signup/signup_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/password_input_text_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class SignUpScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SignUpController>(SignUpController());
  }
}

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: AppStrings.createAccount,
                    style: getBoldStyle(fontSize: 24.sp).copyWith(
                        fontFamily: "Neue", fontWeight: FontWeight.w500)),
                textWidget(
                    text: AppStrings.inputYourDetailsCreate,
                    style: getLightStyle(fontSize: 12.sp, color: grey2)
                        .copyWith(fontWeight: FontWeight.w300)),
                body(context, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context, double width) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 15.sp),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tabButtons(),
                signUpPageView(context, width),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 22.sp,
                    ),
                    signUp(onTap: () => controller.routeToLogin()),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: textWidget(
                          text: AppStrings.or,
                          style: getRegularStyle(color: grey2)
                              .copyWith(fontWeight: FontWeight.w400)),
                    ),
                    googleSignUp(
                      onTap: controller.googleSignUp,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              height: 34.sp,
            ),

            // bottom image
            SvgPicture.asset(ImageAssets.authImage1),
          ],
        ),
      ),
    );
  }

  Widget googleSignUp({void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(ImageAssets.google),
          const SizedBox(
            width: 6,
          ),
          textWidget(
              text: AppStrings.signUpWithGoogle,
              style: getRegularStyle(color: greyShade)
                  .copyWith(fontWeight: FontWeight.w400))
        ],
      ),
    );
  }

  Widget signUpPageView(BuildContext context, double width) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: (int page) {
          controller.onPageChanged(page);
        },
        children: [
          /// car renter registration page
          SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: controller.signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalInputTextWidget(
                        title: AppStrings.fullName,
                        expectedVariable: "fullName",
                        hintText: AppStrings.nameHintText,
                        textInputType: TextInputType.name,
                        controller: controller.fullNameController,
                      ),
                      SizedBox(
                        height: 16.sp,
                      ),
                      NormalInputTextWidget(
                        title: AppStrings.email,
                        expectedVariable: "email",
                        hintText: AppStrings.emailHintText,
                        controller: controller.emailController,
                      ),
                      SizedBox(
                        height: 16.sp,
                      ),
                      NormalInputTextWidget(
                        title: AppStrings.phoneNumber,
                        expectedVariable: "phone",
                        hintText: AppStrings.phoneHintText,
                        controller: controller.phoneNoController,
                         inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                    ],
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
                        height: 16.sp,
                      ),
                    ],
                  ),
                ),
                NormalInputTextWidget(
                  title: '',
                  hasRichTitle: true,
                  richTitle: AppStrings.referralCode,
                  richSubTitle: AppStrings.optional,
                  // expectedVariable: "",
                  hintText: AppStrings.referralCodeHint,
                  textInputType: TextInputType.name,
                  controller: controller.referralCodeController,
                ),
                SizedBox(
                  height: 40.sp,
                ),
                controller.isLoading.isTrue
                    ? centerLoadingIcon()
                    : GtiButton(
                        text: AppStrings.createAccount,
                        width: width,
                        onTap: () => controller.processSignup(),
                        isLoading: controller.isLoading.value,
                      ),
                SizedBox(
                  height: 26.sp,
                ),
              ],
            ),
          ),
          ///// renter registration page
          SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: controller.ownerSignUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalInputTextWidget(
                    title: AppStrings.fullName,
                    expectedVariable: "fullName",
                    hintText: AppStrings.nameHintText,
                    textInputType: TextInputType.name,
                    controller: controller.ownerFullNameController,
                  ),
                  SizedBox(
                    height: 16.sp,
                  ),
                  NormalInputTextWidget(
                    title: AppStrings.email,
                    expectedVariable: "email",
                    hintText: AppStrings.emailHintText,
                    textInputType: TextInputType.emailAddress,
                    controller: controller.ownerEmailController,
                  ),
                  SizedBox(
                    height: 16.sp,
                  ),
                  NormalInputTextWidget(
                    title: AppStrings.phoneNumber,
                    expectedVariable: "phone",
                    hintText: AppStrings.phoneHintText,
                    textInputType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                    ],
                    controller: controller.ownerPhoneNoController,
                  ),
                  SizedBox(
                    height: 16.sp,
                  ),
                  PasswordInputTextWidget(
                    title: AppStrings.password,
                    controller: controller.ownerPasswordController,
                    expectedVariable: 'password',
                    isObscureValue: controller.showPassword.value,
                    onTap: () => controller.obscurePassword(),
                  ),
                  SizedBox(
                    height: 40.sp,
                  ),
                  controller.isLoading.isTrue
                      ? centerLoadingIcon()
                      : GtiButton(
                          text: AppStrings.createAccount,
                          width: width,
                          onTap: controller.processSignup,
                        ),
                  SizedBox(
                    height: 26.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabButtons() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          // color: white,
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
          border: Border.all(color: primaryColor, width: 0.4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GtiButton(
            text: AppStrings.renter,
            style: getRegularStyle(
                color: controller.currentIndex.value == 0 ? white : grey3),
            width: 150.sp,
            height: 33.sp,
            color: controller.currentIndex.value == 0
                ? primaryColor
                : backgroundColor,
            onTap: () {
              controller.onPageChanged(0);
            },
          ),
          GtiButton(
            text: AppStrings.partner,
            style: getRegularStyle(
                color: controller.currentIndex.value == 1 ? white : grey3),
            width: 150.sp,
            height: 33.sp,
            color: controller.currentIndex.value == 1
                ? primaryColor
                : backgroundColor,
            onTap: () {
              controller.onPageChanged(1);
            },
          ),
        ],
      ),
    );
  }

  Widget signUp({void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          text: "${AppStrings.alreadyHaveAccount} ",
          style: getRegularStyle(color: grey2)
              .copyWith(fontWeight: FontWeight.w500),
          children: <TextSpan>[
            TextSpan(
              text: AppStrings.signIn,
              style: getRegularStyle().copyWith(fontWeight: FontWeight.w400),
            ),
            // can add more TextSpans here...
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(ImageAssets.appLogoRide),
        InkWell(
          onTap: () {
            controller.routeToLogin();
          },
          child: textWidget(
              text: "skip_to_login".tr,
              style: getMediumStyle(color: primaryColor)),
        ),
      ],
    );
  }
}
