import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/shared_widgets/upload_image_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class OccupationScreen extends GetView<IdentityVerificationController> {
  const OccupationScreen([Key? key]) : super(key: key);
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
      onTap: controller.goBack,
      leading: const Icon(Icons.arrow_back),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.occupation,
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
              NormalInputTextWidget(
                expectedVariable: 'field',
                title: AppStrings.inputOccupation,
                hintText: AppStrings.inputAddressSm,
                controller: controller.homeAddressController,
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
            height: 40.sp,
            width: 370,
            text: AppStrings.save,
            // color: secondaryColor,
            onTap: () {},
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
