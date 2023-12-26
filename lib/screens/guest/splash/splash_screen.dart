import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/guest/splash/splash_controller.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          backgroundColor: primaryColor,
          body: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.35.sp,
                right: 0,
                left: 0,
                child: Transform.scale(
                  scale: controller.animationValue.value,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0.w,
                      ),
                      child: SvgPicture.asset(ImageAssets.appLogo),
                    ),
                  ),
                ),
              ),
              Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      SvgPicture.asset(ImageAssets.splashCar),
                      Container(
                        height: 12.sp,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: white),
                      )
                    ],
                  )),
            ],
          ));
    });
  }
}
