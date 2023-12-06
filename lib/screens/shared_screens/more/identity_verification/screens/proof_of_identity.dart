import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/shared_widgets/upload_image_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ProofOfIdentityScreen extends GetView<IdentityVerificationController> {
  const ProofOfIdentityScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(),
      body: body(size, context, controller: controller),
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
          text: AppStrings.proofOfIdentity,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context,
      {required IdentityVerificationController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: getRegularStyle(fontSize: 12.sp, color: grey2)),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              textWidget(
                  text: AppStrings.chooseYourIdentityType,
                  textOverflow: TextOverflow.visible,
                  style: getRegularStyle(fontSize: 12.sp, color: grey2)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  checkBoxWithText(
                      title: AppStrings.nationalId,
                      selectedIdType: controller.selectedIdType.value,
                      onTap: controller.onSelectIdType,
                      idType: IdType.nationalId),
                  checkBoxWithText(
                      title: AppStrings.passport,
                      selectedIdType: controller.selectedIdType.value,
                      onTap: controller.onSelectIdType,
                      idType: IdType.passport),
                  checkBoxWithText(
                      title: AppStrings.drivingLicense,
                      selectedIdType: controller.selectedIdType.value,
                      onTap: controller.onSelectIdType,
                      idType: IdType.driverLicense),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              imageUploadWidget(
                title: AppStrings.uploadProofOfIdentity,
                body: AppStrings.pleaseMakeSurePicIsClear,
                onTap: () {},
              ),
              const SizedBox(height: 20),
            ],
          )),
    );
  }

  Widget checkBoxWithText(
      {
      // required bool selected,
      required IdType idType,
      required IdType selectedIdType,
      required String title,
      required void Function(IdType)? onTap}) {
    return GestureDetector(
      onTap: () => onTap!(idType),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sqaureCheckBox(
              padingWidth: 2.sp,
              marginRight: 4.sp,
              border: Border.all(
                  color: idType == selectedIdType ? primaryColor : grey1,
                  width: 1.6),
              color:
                  idType == selectedIdType ? primaryColor : Colors.transparent),
          const SizedBox(
            width: 5,
          ),
          textWidget(
              text: title,
              style: getRegularStyle(
                  fontSize: 10.sp,
                  color: idType == selectedIdType ? primaryColor : grey1)),
        ],
      ),
    );
  }
}
