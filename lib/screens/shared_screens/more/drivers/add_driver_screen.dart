import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/shared_screens/more/drivers/drivers_controller.dart';
import 'package:gti_rides/shared_widgets/camera_option_sheet.dart';
import 'package:gti_rides/shared_widgets/date_container.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/shared_widgets/upload_image_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class AddDriverScreen extends GetView<DriversController> {
  const AddDriverScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put(DriversController());
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
          text: AppStrings.addNewDriver,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context, {required DriversController controller}) {
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
                    hintText: AppStrings.fullNameHint,
                    controller: controller.fullNameController,
                  ),
                  const SizedBox(height: 24),
                  NormalInputTextWidget(
                    expectedVariable: 'phone',
                    title: AppStrings.driversNumber,
                    hintText: AppStrings.phoneHintText,
                    textInputType: TextInputType.phone,
                    controller: controller.phoneNoController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return fetchErrorText(expectedTextVariable: "phone");
                      }
                      if (value.length != 11) {
                        return fetchErrorText(
                            expectedTextVariable: 'phone length');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  NormalInputTextWidget(
                    expectedVariable: 'field',
                    title: AppStrings.driversEmail,
                    hintText: AppStrings.emailHintText,
                    controller: controller.emailController,
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return fetchErrorText(expectedTextVariable: "field");
                      }
                      if (!value.contains('.com')) {
                        return fetchErrorText(expectedTextVariable: '.com');
                      }
                      return null;
                    },
                    // initialValue: 'email',
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
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 24),
                  // NormalInputTextWidget(
                  //   expectedVariable: 'field',
                  //   title: AppStrings.licenseExpireyDate,
                  //   hintText: AppStrings.licenseExpireyDate,
                  //   textInputType: TextInputType.none,
                  //   controller: controller.licenceExpiryDateController,
                  //   onTap: () async {
                  //   // var data =
                  //   //     await Get.toNamed(AppLinks.chooseTripDate, arguments: {
                  //   //   "appBarTitle": AppStrings.selectExpiryDate,
                  //   //   "isSingleDate": true
                  //     var data =
                  //       await Get.toNamed(AppLinks.chooseTripDate, arguments: {
                  //     "appBarTitle": AppStrings.selectExpiryDate,
                  //     "to": AppStrings.to,
                  //     "from": AppStrings.from
                  //   });

                  //   // Handle the selected date here
                  //   print('Selected Date page: $data');
                  //   controller.selectedExpiryDate.value = data['selectedExpiryDate'] ?? '';
                  //   // controller.endDateTime.value = data['end'] ?? '';

                  //   print('Selected Expiry Date : ${data['selectedExpiryDate']}');
                  // },
                  // ),

                  dateContainer(
                    size,
                    isCentered: true,
                    alignment: Alignment.centerLeft,
                    title: AppStrings.licenseExpireyDate,
                    color: controller.selectedExpiryDate.value.isEmpty
                        ? grey1
                        : grey5,
                    text: controller.selectedExpiryDate.value.isEmpty
                        ? AppStrings.dateTimeHintText
                        : controller.selectedExpiryDate.value,
                    onTap: () async {
                      var data = await Get.toNamed(AppLinks.chooseTripDate,
                          arguments: {
                            "appBarTitle": AppStrings.selectExpiryDate,
                            "enablePastDates": false,
                            "isSingleDateSelection": true,
                            "to": AppStrings.to,
                            "from": AppStrings.from
                          });

                      // Handle the selected date here
                      print('Selected Date page: $data');
                      if (data != null && data['selectedExpiryDate'] != null) {
                        controller.selectedExpiryDate.value =
                            data['selectedExpiryDate'];
                      }
                    },
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
