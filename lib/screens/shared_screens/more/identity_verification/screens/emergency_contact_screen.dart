import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class EmergencyContactScreen extends GetView<IdentityVerificationController> {
  const EmergencyContactScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put(IdentityVerificationController());
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(controller),
      body: body(size, context, controller: controller),
      // }
    );
  }

  AppBar appBar(IdentityVerificationController controller) {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.emergencyContact,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context,
      {required IdentityVerificationController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Obx(() => Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: controller.updateFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalInputTextWidget(
                      expectedVariable: 'field',
                      title: AppStrings.inputEmergencyNumber,
                      hintText: AppStrings.phoneHintText,
                      controller: controller.emergencyNumberController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        
                      ],
                      textInputType: TextInputType.phone,),
                  const SizedBox(height: 24),
                  NormalInputTextWidget(
                    expectedVariable: 'field',
                    title: AppStrings.name,
                    hintText: AppStrings.inputName,
                    controller: controller.emergencyNameController,
                  ),
                  const SizedBox(height: 24),
                  NormalInputTextWidget(
                    expectedVariable: 'field',
                    title: AppStrings.relationship,
                    hintText: AppStrings.inputRelationship,
                    controller: controller.relationshipController,
                  ),
                  const SizedBox(height: 74),
                  saveButton(),
                ],
              ),
            ),
          )),
    );
  }

  Widget saveButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 50.sp,
            width: 370,
            text: AppStrings.save,
            // color: secondaryColor,
            onTap: controller.updateKyc,
            isLoading: controller.isLoading.value,
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
