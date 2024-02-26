import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/drivers/drivers_controller.dart';
import 'package:gti_rides/screens/shared_screens/more/drivers/edit_driver_details/edit_driver_controller.dart';
import 'package:gti_rides/shared_widgets/camera_option_sheet.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/shared_widgets/upload_image_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class EditDriverScreen extends GetView<EditDriversController> {
  const EditDriverScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put(EditDriversController());
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
          text: AppStrings.editDriver,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context, {required EditDriversController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Obx(() => SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: controller.createDriverFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 20.sp),
                  NormalInputTextWidget(
                    expectedVariable: 'field',
                    title: AppStrings.driverFullName,
                    hintText: controller.fullName.value,
                    controller: controller.fullNameController,
                    readOnly: true, showCursor: false,
                  ),
                  const SizedBox(height: 24),
                  NormalInputTextWidget(
                    expectedVariable: 'field',
                    title: AppStrings.driversNumber,
                    hintText: controller.driverNumber.value,
                    textInputType: TextInputType.phone,
                    controller: controller.phoneNoController,
                    
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                    ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return fetchErrorText(expectedTextVariable: "phone");
                        }
                        if (value.length != 11) {
                          return fetchErrorText(expectedTextVariable: 'phone length');
                        }
                        return null;
                      },
                  ),
                  const SizedBox(height: 24),
                  NormalInputTextWidget(
                    expectedVariable: 'field',
                    title: AppStrings.driversEmail,
                    hintText: controller.driverEmail.value,
                    controller: controller.emailController,
                    textInputType: TextInputType.emailAddress,
                    readOnly: true, showCursor: false,
                  ),
                  const SizedBox(height: 24),
                  NormalInputTextWidget(
                    expectedVariable: 'field',
                    title: AppStrings.licenseNumber,
                    hintText: AppStrings.licenseNumber,
                    controller: controller.licenceNoController,
                    textInputType: TextInputType.name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                    ],
                  ),
                  const SizedBox(height: 24),
                  NormalInputTextWidget(
                    expectedVariable: 'field',
                    title: AppStrings.licenseExpireyDate,
                    hintText: AppStrings.licenseExpireyDate,
                    textInputType: TextInputType.datetime,
                    controller: controller.licenceExpiryDateController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  imageUploadWidget(
                    title: AppStrings.uploadDriversLicense,
                    body: controller.pickedImageName.value.isNotEmpty
                        ? controller.pickedImageName.value
                        : AppStrings.pleaseMakeSurePicIsClear,
                    onTap: () {
                      selectCameraOptionSheet(
                        size,
                        onCameraOpen: () => controller
                            .openCamera()
                            .then((value) => controller.goBack()),
                        onGelleryOpen: () => controller
                            .openGallery()
                            .then((value) => controller.goBack()),
                      );
                    },
                  ),
                  const SizedBox(height: 74),
                  contButton(),
                ],
              ),
            ),
          )),
    );
  }

  Widget contButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            width: 370,
            text: AppStrings.cont,
            // color: secondaryColor,
            onTap: () {
              controller.createDriver();
              // successDialog(
              //     title: AppStrings.driverAddedMessage,
              //     body: AppStrings.thankYouForAddingDriver,
              //     buttonTitle: AppStrings.home,
              //     onTap: controller.goBack1);
            },
            isLoading: controller.isLoading.value,
          );
  }
}
