import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/more/drivers/drivers_controller.dart';
import 'package:gti_rides/screens/more/identity_verification/identity_verification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Obx(() => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalInputTextWidget(
                  expectedVariable: 'field',
                  title: AppStrings.driverFullName,
                  hintText: AppStrings.fullNameHint,
                  // controller: controller.nameController,
                ),
                const SizedBox(height: 24),
                NormalInputTextWidget(
                  expectedVariable: 'field',
                  title: AppStrings.driversNumber,
                  hintText: AppStrings.phoneHintText,
                  textInputType: TextInputType.phone,
                  // controller: controller.homeAddressController,
                ),
                const SizedBox(height: 24),
                NormalInputTextWidget(
                  expectedVariable: 'field',
                  title: AppStrings.driversEmail,
                  hintText: AppStrings.emailHintText,
                  // controller: controller.relationshipController,
                ),
                const SizedBox(height: 74),
                contButton(),
              ],
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
              successDialog(
                  title: AppStrings.driverAddedMessage,
                  body: AppStrings.thankYouForAddingDriver,
                  buttonTitle: AppStrings.home,
                  onTap: controller.routeToHome);
            },
            isLoading: controller.isLoading.value,
          );
  }
}
