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
import 'package:gti_rides/utils/utils.dart';

class PartnerIdentityVerificationScreen
    extends GetView<IdentityVerificationController> {
  PartnerIdentityVerificationScreen([Key? key]) : super(key: key);
  final controller = Get.put(IdentityVerificationController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(controller),
      body: Obx(() => body(size, context)),
      // }
    );
  }

  AppBar appBar(IdentityVerificationController controller) {
    return gtiAppBar(
      onTap: () => controller.goBack(),
      leading: Transform.scale(
          // gainApprovalCarLIsting
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
    final userKyc = controller.userKyc.value.data;
    return SingleChildScrollView(
      child: GetBuilder<IdentityVerificationController>(
        init: IdentityVerificationController(),
        initState: (_) {},
        builder: (_) {
          return Column(
            children: [
              const SizedBox(height: 20),
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
                  title: AppStrings.gender,
                  subTitle: userKyc != []
                      ? userKyc![0]["gender"] ?? AppStrings.selectGender
                      : AppStrings.selectGender,
                  onTap: controller.routeToSelectGender),
              identityVerificationWidget(
                  title: AppStrings.dob,
                  subTitle: userKyc != null &&
                          userKyc.isNotEmpty &&
                          userKyc[0] != null &&
                          userKyc[0]["dateOfBirth"] != null
                      ? formatDate1(date: userKyc[0]["dateOfBirth"]) ??
                          AppStrings.provideDob
                      : AppStrings.provideDob,
                  onTap: controller.routeToDob),

              // address verification
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
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
                      subTitle: userKyc != []
                          ? userKyc![0]["homeAddress"] ??
                              AppStrings.provideHomeAddress
                          : AppStrings.provideHomeAddress,
                      onTap: controller.routeToHomeAddress),
                ],
              ),
              Visibility(
                  visible: controller.isKycUpdate.isTrue,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  )),
              contButton(userKyc),

              SizedBox(
                height: size.height * 0.07,
              ),
            ],
          );
        },
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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

  Widget contButton(List<dynamic>? userKyc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: controller.isLoading.isTrue
          ? centerLoadingIcon()
          : GtiButton(
              // height: 50.sp,
              width: 300.sp,
              text: AppStrings.cont,
              // color: secondaryColor,
              // isDisabled: true,
              isDisabled:  userKyc![0]["homeAddress"] == null ||
                      userKyc[0]["dateOfBirth"] == null ||
                      userKyc[0]["gender"] == null,

              onTap: controller.goBack,
              isLoading: controller.isLoading.value,
            ),
    );
  }
}
