import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/shared_widgets/dropdown_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class GenderScreen extends GetView<IdentityVerificationController> {
  const GenderScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final controller = Get.put(AccountVerificationController());
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(),
      body: body(size, context, controller: controller),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.gender,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context,
      {required IdentityVerificationController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // textWidget(text: AppStrings.selectGender, style: getRegularStyle()),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: controller.updateFormKey,
                child: dropdownWidget1(
                    context: context,
                    hintText: 'Select gender',
                    // selectedUserValue: AppStrings.male,
                    values: controller.gender,
                    expectedVariable: 'gender',
                    onChange: (value) {
                      controller.selectedGender.value = value;
                     
                      print('Selected value: $value ${controller.selectedGender.value}');
                    },
                    title: AppStrings.selectGender),
              ),
              const SizedBox(height: 74),
              saveButton(),
            ],
          )),
    );
  }

  Widget saveButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 40.sp,
            width: 370,
            text: AppStrings.save,
            // color: secondaryColor,
            onTap: controller.updateKyc,
            isLoading: controller.isLoading.value,
          );
  }
}
