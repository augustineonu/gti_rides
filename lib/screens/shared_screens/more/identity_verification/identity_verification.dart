import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class IdentityVerifiationBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<IdentityVerificationController>(IdentityVerificationController());
  }
}

class IdentityVerificationScreen
    extends GetView<IdentityVerificationController> {
  const IdentityVerificationScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(),
      body: body(size, context),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: () => controller.goBack(),
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.identityVerification,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Identity verification
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                SvgPicture.asset(ImageAssets.identityV),
                const SizedBox(width: 6),
                textWidget(
                    text: AppStrings.identityVerificationCaps,
                    style: getBoldStyle()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          identityVerificationWidget(
              title: AppStrings.proofOfIdentity,
              subTitle: AppStrings.addDocument,
              onTap: controller.routeToProofOfIdentity),
          identityVerificationWidget(
              title: AppStrings.gender,
              subTitle: AppStrings.selectGender,
              onTap: controller.routeToSelectGender),
          identityVerificationWidget(
              title: AppStrings.dob,
              subTitle: AppStrings.provideDob,
              onTap: () {}),
          identityVerificationWidget(
              title: AppStrings.emergencyContactDetails,
              subTitle: AppStrings.inputEmergencyDetails,
              onTap: controller.routeToEmergencyContact),

          // address verification
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageAssets.location1,
                  height: 18.sp,
                ),
                const SizedBox(width: 6),
                textWidget(
                    text: AppStrings.addressVerificationCaps,
                    style: getBoldStyle()),
              ],
            ),
          ),
          identityVerificationWidget(
              title: AppStrings.homeAddress,
              subTitle: AppStrings.provideHomeAddress,
              onTap: controller.routeToHomeAddress),
          identityVerificationWidget(
              title: AppStrings.officeAddress,
              subTitle: AppStrings.addOfficeAddress,
              onTap: controller.routeToOfficeAddress),
          identityVerificationWidget(
              title: AppStrings.occupation,
              subTitle: AppStrings.provideOccupation,
              onTap: controller.routeToOccupation),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageAssets.pencil,
                  height: 18.sp,
                ),
                const SizedBox(width: 6),
                textWidget(
                    text: AppStrings.accountStatusCaps, style: getBoldStyle()),
              ],
            ),
          ),
          identityVerificationWidget(
              title: AppStrings.approved,
              titleColor: green,
              subTitle: AppStrings.youCanProceedToRent,
              onTap: () {}),
          SizedBox(
            height: size.height * 0.07,
          ),

          // textWidget(text: controller.testString(), style: getMediumStyle()),
        ],
      ),
    );
  }

  Widget identityVerificationWidget(
      {required String title,
      required String subTitle,
      void Function()? onTap,
      Color? titleColor}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textWidget(
                    text: title,
                    style: getRegularStyle(color: titleColor ?? black)),
                textWidget(
                    text: subTitle,
                    style: getRegularStyle(fontSize: 12.sp, color: grey2)),
              ],
            ),
          ),
        ),
        divider(color: borderColor),
      ],
    );
  }

  Widget saveButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 50.sp,
            width: 300.sp,
            text: AppStrings.save,
            // color: secondaryColor,
            onTap: () {},
            isLoading: controller.isLoading.value,
          );
  }
}