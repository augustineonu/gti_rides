import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/update_kyc/update_kyc_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class UpdateKycBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<UpdateKycController>(UpdateKycController());
  }
}

class UpdateKycScreen extends GetView<UpdateKycController> {
  const UpdateKycScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: body(size, context)),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: () => controller.goBack(),
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(
            ImageAssets.arrowLeft,
          
          color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.addToContinue,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
            child: Row(
              children: [
                textWidget(
                    text: AppStrings.addDisplayPic, style: getBoldStyle()),
              ],
            ),
          ),

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
              onTap: () {}),
          identityVerificationWidget(
              title: AppStrings.gender,
              subTitle: AppStrings.selectGender,
              onTap: () {}),
          identityVerificationWidget(
              title: AppStrings.dob,
              subTitle: AppStrings.provideDob,
              onTap: () {}),
          identityVerificationWidget(
              title: AppStrings.emergencyContactDetails,
              subTitle: AppStrings.inputEmergencyDetails,
              onTap: () {}),
          identityVerificationWidget(
              title: AppStrings.driversLicense,
              subTitle: AppStrings.provideDriversLicense,
              onTap: () {}),

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
              onTap: () {}),
          identityVerificationWidget(
              title: AppStrings.officeAddress,
              subTitle: AppStrings.addOfficeAddress,
              onTap: () {}),
          identityVerificationWidget(
              title: AppStrings.occupation,
              subTitle: AppStrings.provideOccupation,
              onTap: () {}),
          SizedBox(
            height: size.height * 0.07,
          ),
          continueButton(),
          textWidget(text: controller.testString(), style: getMediumStyle()),
        ],
      ),
    );
  }

  Widget identityVerificationWidget({
    required String title,
    required String subTitle,
    void Function()? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textWidget(text: title, style: getRegularStyle(color: black)),
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

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GtiButton(
              height: 50.sp,
              width: 350.sp,
              text: "continue".tr,
              color: primaryColor,
              onTap: controller.routeToPaymentSummary,
              isLoading: controller.isLoading.value,
            ),
          );
  }
}
