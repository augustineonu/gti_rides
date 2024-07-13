import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

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
    final controller = Get.put(IdentityVerificationController());
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
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: controller.isKycUpdate.value
              ? controller.appBarTitle.value
              : AppStrings.identityVerification,
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
              Visibility(
                visible: controller.isKycUpdate.isTrue
                    ? controller.tripData.value.tripType == "selfDrive" ||
                        controller.tripData.value.tripType == 'self drive'
                    : true,
                child: identityVerificationWidget(
                    title: AppStrings.proofOfIdentity,
                    subTitle: userKyc != []
                        ? userKyc![0]["licenceNumber"] != null
                            ? AppStrings.driversLicense
                            : AppStrings.addDocument
                        : AppStrings.addDocument,
                    onTap: controller.routeToProofOfIdentity),
              ),
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
              identityVerificationWidget(
                  title: AppStrings.emergencyContactDetails,
                  subTitle: userKyc != []
                      ? (userKyc![0]["emergencyName"] != null &&
                              userKyc![0]["emergencyNumber"] != null)
                          ? "${userKyc![0]["emergencyName"]} - ${userKyc![0]["emergencyNumber"]}"
                          : AppStrings.inputEmergencyDetails
                      : AppStrings.inputEmergencyDetails,
                  onTap: controller.routeToEmergencyContact),

              // address verification
              Visibility(
                visible: controller.isKycUpdate.isTrue
                    ? controller.tripData.value.tripType == "selfDrive" ||
                        controller.tripData.value.tripType == 'self drive'
                    : true,
                child: Column(
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
                    identityVerificationWidget(
                        title: AppStrings.officeAddress,
                        subTitle: userKyc != []
                            ? userKyc![0]["officeAddress"] ??
                                AppStrings.addOfficeAddress
                            : AppStrings.addOfficeAddress,
                        onTap: controller.routeToOfficeAddress),
                    identityVerificationWidget(
                        title: AppStrings.occupation,
                        subTitle: userKyc != []
                            ? userKyc![0]["occupation"] ??
                                AppStrings.provideOccupation
                            : AppStrings.provideOccupation,
                        onTap: controller.routeToOccupation),
                  ],
                ),
              ),
              Visibility(
                  visible: controller.tripData.value.tripType == 'chauffeur',
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  )),
              controller.isKycUpdate.value
                  ? contButton(userKyc)
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                ImageAssets.pencil,
                                height: 18.sp,
                              ),
                              const SizedBox(width: 6),
                              textWidget(
                                  text: AppStrings.accountStatusCaps,
                                  style: getBoldStyle()),
                            ],
                          ),
                        ),
                        identityVerificationWidget(
                            title:
                                // controller.user.value.status
                                //             ?.toLowerCase() ==
                                //         "pending"
                                controller.user.value.status == false
                                    ? AppStrings.pending
                                    : controller.user.value.status == true
                                        ? AppStrings.approved
                                        : AppStrings.suspended,
                            titleColor: controller.user.value.status == false
                                ? yellow
                                : controller.user.value.status == true
                                    ? green
                                    : red,
                            subTitle: controller.user.value.status == false
                                ? AppStrings.pendingApproval
                                : controller.user.value.status == true
                                    ? userService.user.value.userType ==
                                            "renter"
                                        ? AppStrings.youCanProceedToRent
                                        : "Get exciting bonuses when you list your car for rental purposes"
                                    : AppStrings.accountSuspended,
                            onTap: () {}),
                      ],
                    ),
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
              isDisabled: controller.tripData.value.tripType == 'chauffeur' &&
                      userKyc![0]['dateOfBirth'] != null &&
                      userKyc[0]["emergencyName"] != null &&
                      userKyc[0]["gender"] != null
                  ? false
                  : userKyc![0]["officeAddress"] == null ||
                      userKyc[0]["homeAddress"] == null ||
                      userKyc[0]["occupation"] == null ||
                      userKyc[0]["dateOfBirth"] == null ||
                      userKyc[0]["emergencyName"] == null ||
                      userKyc[0]["gender"] == null ||
                      userKyc[0]["licenceNumber"] == null,

              onTap: controller.proceedToPayment,
              isLoading: controller.isLoading.value,
            ),
    );
  }
}
