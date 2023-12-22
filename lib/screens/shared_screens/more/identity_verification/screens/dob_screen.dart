import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/screens/shared_screens/more/identity_verification/home_address/home_address_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class DateOfBirthScreen extends GetView<IdentityVerificationController> {
  const DateOfBirthScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IdentityVerificationController());
    var size = MediaQuery.of(context).size;
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
          text: AppStrings.dob,
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
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: controller.updateFormKey,
                child: NormalInputTextWidget(
                  expectedVariable: 'field',
                  title: AppStrings.inputDob,
                  hintText: AppStrings.dateTimeHintText,
                  controller: controller.officeAddressController,
                  textInputType: TextInputType.datetime,
                ),
              ),
              const SizedBox(height: 32),
              saveButton(),
            ],
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



}
