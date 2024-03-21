import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/shared_screens/more/identity_verification/home_address/home_address_controller.dart';
import 'package:gti_rides/screens/shared_screens/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/camera_option_sheet.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/shared_widgets/upload_image_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ProofOfIdentityScreen extends GetView<HomeAddressController> {
  const ProofOfIdentityScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put(HomeAddressController());
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(controller),
      body: body(size, context, controller: controller),
      // }
    );
  }

  AppBar appBar(HomeAddressController controller) {
    return gtiAppBar(
      onTap: () => controller.goBack(),
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.proofOfIdentity,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context, {required HomeAddressController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Obx(() => SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: controller.updateFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 255.sp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                            text: AppStrings.selectDocument,
                            textOverflow: TextOverflow.visible,
                            style: getBoldStyle()),
                        const SizedBox(
                          height: 10,
                        ),
                        textWidget(
                            text: AppStrings.uploadToCompleteApproval,
                            textOverflow: TextOverflow.visible,
                            style:
                                getRegularStyle(fontSize: 12.sp, color: grey2)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  NormalInputTextWidget(
                    title: AppStrings.driversLicenseNo,
                    expectedVariable: "number",
                    hintText: AppStrings.inputDetails,
                    textInputType: TextInputType.text,
                    controller: controller.licenseNoController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                      FilteringTextInputFormatter.digitsOnly,

                      // FilteringTextInputFormatter.allow(RegExp(
                      // r'[0-9.]')), // Allow digits and a decimal point
                    ],
                  ),
                  const SizedBox(height: 20),
                  NormalInputTextWidget(
                    title: AppStrings.licenseExpireyDate,
                    expectedVariable: "field",
                    hintText: AppStrings.inputDetails,
                    textInputType: TextInputType.none,
                    controller: controller.expiryDateController
                      ..text = controller.selectedExpiryDate.value,
                    readOnly: true,
                    onTap: () async {
                      var data = await Get.toNamed(AppLinks.chooseTripDate,
                          arguments: {
                            "appBarTitle": AppStrings.selectExpiryDate,
                            "enablePastDates": true,
                            "isSingleDateSelection": true,
                            "to": AppStrings.to,
                            "from": AppStrings.from,
                            "isExpiryDateSelection": true
                          });

                      // Handle the selected date here
                      print('Selected Date page: $data');
                      if (data != null && data['selectedExpiryDate'] != null) {
                        controller.selectedExpiryDate.value =
                            data['selectedExpiryDate'];
                        print("value ${controller.selectedExpiryDate.value}");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  imageUploadWidget(
                    title: AppStrings.uploadFrontView,
                    body: controller.frontImageName.value.isNotEmpty
                        ? controller.frontImageName.value
                        : AppStrings.pleaseMakeSurePicIsClear,
                    onTap: () {
                      selectCameraOptionSheet(
                        size,
                        onCameraOpen: () => controller
                            .openFrontCamera()
                            .then((value) => routeService.goBack()),
                        onGelleryOpen: () => controller
                            .openFrontGallery()
                            .then((value) => routeService.goBack()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  imageUploadWidget(
                    title: AppStrings.uploadBackView,
                    body: controller.homeAddressName.value.isNotEmpty
                        ? controller.homeAddressName.value
                        : AppStrings.pleaseMakeSurePicIsClear,
                    onTap: () {
                      controller.isLicenseUpload.value = true;
                      selectCameraOptionSheet(
                        size,
                        onCameraOpen: () => controller
                            .openCamera()
                            .then((value) => routeService.goBack()),
                        onGelleryOpen: controller.openGallery,
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                  controller.isLoading.value
                      ? centerLoadingIcon()
                      : GtiButton(
                          text: AppStrings.save,
                          width: size.width,
                          onTap: controller.updateIdentityCard,
                        ),
                ],
              ),
            ),
          )),
    );
  }
}
