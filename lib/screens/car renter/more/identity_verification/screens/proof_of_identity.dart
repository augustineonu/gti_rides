import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/car_selection_result/update_kyc/update_kyc_controller.dart';
import 'package:gti_rides/screens/car%20renter/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

// class IdentityVerifiationBinding extends Bindings {
//   @override
//   void dependencies() {
//     // TODO: implement dependencies
//     Get.put<IdentityVerificationController>(IdentityVerificationController());
//   }
// }

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
      leading: const Icon(Icons.arrow_back),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    SizedBox(
                      height: 10,
                    ),
                    textWidget(
                        text: AppStrings.uploadToCompleteApproval,
                        textOverflow: TextOverflow.visible,
                        style: getRegularStyle(fontSize: 12.sp, color: grey2)),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              textWidget(
                  text: AppStrings.chooseYourIdentityType,
                  textOverflow: TextOverflow.visible,
                  style: getRegularStyle(fontSize: 12.sp, color: grey2)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // checkBoxWithText(
                  //     title: 'Natiional ID',
                  //     selected: controller.selectedIdType.value,
                  //     onTap: controller.onSelectIdType),
                  // checkBoxWithText(
                  //     title: 'Natiional ID',
                  //     selected: controller.selectedIdType.value,
                  //     onTap: controller.onSelectIdType),
                  // checkBoxWithText(
                  //     title: 'Natiional ID',
                  //     selected: controller.selectedIdType.value,
                  //     onTap: controller.onSelectIdType),
                ],
              ),
              const SizedBox(height: 20),
              identityVerificationWidget(
                  title: AppStrings.proofOfIdentity,
                  subTitle: AppStrings.addDocument,
                  onTap: () {}),

              SizedBox(
                height: size.height * 0.07,
              ),

              // textWidget(text: controller.testString(), style: getMediumStyle()),
            ],
          )),
    );
  }

  Widget checkBoxWithText(
      {required bool selected,
      required String title,
      required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sqaureCheckBox(
              padingWidth: 2.sp,
              marginRight: 4.sp,
              border: Border.all(
                  color: selected ? primaryColor : grey1, width: 1.6),
              color: selected ? primaryColor : Colors.transparent),
          const SizedBox(
            width: 5,
          ),
          textWidget(
              text: title,
              style: getRegularStyle(
                  fontSize: 10.sp, color: selected ? primaryColor : grey1)),
        ],
      ),
    );
  }

  Widget identityVerificationWidget(
      {required String title,
      required String subTitle,
      void Function()? onTap,
      Color? titleColor,
      IdentityVerificationController? controller}) {
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
}
