import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/account_details/account_verification/acount_verification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class EmailScreenBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<AccountVerificationController>(AccountVerificationController());
  }
}

class EmailScreen extends GetView<AccountVerificationController> {
  const EmailScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final controller =
        Get.put<AccountVerificationController>(AccountVerificationController());
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: gtiAppBar(
          onTap: controller.goBack,
          leading: Transform.scale(
              scale: 0.5,
              child: SvgPicture.asset(
                ImageAssets.arrowLeft,
              color: black
              ),
              ),
          centerTitle: true,
          title: textWidget(
              text: AppStrings.email,
              style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
          titleColor: iconColor(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NormalInputTextWidget(
                expectedVariable: 'email',
                title: AppStrings.email,
                hintText: AppStrings.emailHintText,
                textInputType: TextInputType.emailAddress,
                controller: controller.emailController,
              ),
              SizedBox(
                height: 30.sp,
              ),
              continueButton(size),
            ],
          ),
        ));
    // }
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.email,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(size, context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NormalInputTextWidget(
            expectedVariable: 'email',
            title: AppStrings.email,
            hintText: AppStrings.emailHintText,
            textInputType: TextInputType.emailAddress,
            controller: controller.emailController,
          ),
          SizedBox(
            height: 30.sp,
          ),
          continueButton(size),
        ],
      ),
    );
  }

  Widget continueButton(Size size) {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 40.sp,
            width: size.width.sp,
            text: AppStrings.cont,
            onTap: controller.routeToVerifyEmail,
            isLoading: controller.isLoading.value,
          );
  }
}
