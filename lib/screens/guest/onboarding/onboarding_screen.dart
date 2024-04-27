import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/onboarding_content.dart';
import 'package:gti_rides/screens/guest/onboarding/onboarding_controller.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class OnboardingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OnboardingController>(OnboardingController());
  }
}

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(
        () => Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              height: height * 0.74.sp,
              child: PageView.builder(
                  controller: controller.controller,
                  itemCount: OnBoardingContent.onBoardingContents.length,
                  onPageChanged: (int index) => controller.onPageChanged(index),
                  itemBuilder: (BuildContext context, int index) {
                    final content = OnBoardingContent.onBoardingContents[index];
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // SizedBox(height: 141.0.h),
                          Center(
                            child: Image.asset(
                              content.imageUrl,
                              // "Frame 1046.svg",
                              // height: 218.h,
                              width: width.w,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          SizedBox(height: 20.0.h),
                          SizedBox(
                            width: 320.sp,
                            child: Column(
                              children: [
                                Text(
                                  content.title,
                                  textAlign: TextAlign.center,
                                  style: getExtraBoldStyle(fontSize: 24.sp)
                                      .copyWith(
                                          height: 1.3,
                                          fontFamily: "Neue",
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 10.0.h),
                                Text(
                                  content.description,
                                  textAlign: TextAlign.center,
                                  style: getRegularStyle(fontSize: 12.sp)
                                      .copyWith(
                                          height: 1.3,
                                          fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            // const Spacer(),
            body(context, width),
          ],
        ),
      ),
    );
  }

  Widget body(BuildContext context, double width) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              OnBoardingContent.onBoardingContents.length,
              (index) => buildDot(
                context,
                currentIndex: controller.currentIndex.value,
                index: index,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Column(
              children: [
                GtiButton(
                  text: AppStrings.getStartedButtonText,
                  width: width,
                  onTap: controller.routeToSignUp,
                ),
                SizedBox(
                  height: 8.sp,
                ),
                GtiButton(
                  text: AppStrings.loginButtonText,
                  width: width,
                  textColor: primaryColor,
                  hasBorder: true,
                  borderColor: primaryColor,
                  color: white,
                  onTap: controller.routeToLogin,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildDot(
    BuildContext context, {
    required int index,
    required int currentIndex,
    double? width,
  }) {
    return Container(
      height: 5.h,
      width: currentIndex == index ? 18.w : 18.0.w,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0.r),
        color: currentIndex == index ? primaryColor : primaryColorLight,
      ),
    );
  }
}
