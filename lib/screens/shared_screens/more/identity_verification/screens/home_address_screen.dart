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
import 'package:gti_rides/shared_widgets/upload_image_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class HomeAddressScreen extends GetView<HomeAddressController> {
  const HomeAddressScreen([Key? key]) : super(key: key);
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
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.homeAddress,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context,
      {required HomeAddressController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Obx(() => Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: controller.updateFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalInputTextWidget(
                  expectedVariable: 'field',
                  title: AppStrings.inputAddressSm,
                  hintText: AppStrings.inputAddressSm,
                  controller: controller.homeAddressController,
                ),
                const SizedBox(height: 32),
                imageUploadWidget(
                  title: AppStrings.uploadDocumentToProveAddress,
                  body: controller.frontImageName.value.isNotEmpty
                      ? controller.frontImageName.value
                      : AppStrings.pleaseMakeSurePicIsClear,
                  onTap: () {
                    selectOptionSheet(size);
                  },
                ),
              
                const SizedBox(height: 55),
                saveButton(),
              ],
            ),
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

  Future<dynamic> selectOptionSheet(Size size) {

    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: 150,
        width: size.width,
        child: Column(
          children: [
            textWidget(text: AppStrings.selectOption, style: getMediumStyle()),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: GtiButton(
                    width: 120.sp,
                    text: AppStrings.camera,
                    onTap: () => controller.openCamera(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GtiButton(
                    width: 120.sp,
                    text: AppStrings.gallery,
                    onTap: controller.openGallery,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.r), topRight: Radius.circular(0.r))),
    );
  }



}
