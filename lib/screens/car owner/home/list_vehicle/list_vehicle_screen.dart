import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20owner/home/list_vehicle/list_vehicle_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:iconsax/iconsax.dart';

class ListVehicleScreenBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ListVehicleController>(ListVehicleController());
  }
}

class ListVehicleScreen extends GetView<ListVehicleController> {
  const ListVehicleScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put<ListVehicleController>(ListVehicleController());
    return Obx(() => Scaffold(
          appBar: appBar(),
          // body: body(size, context)),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 13.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: listingTracker(
                          subTitle: AppStrings.vehicleType,
                          child: Dash(
                              direction: Axis.horizontal,
                              length: 27.sp,
                              dashLength: 2,
                              dashThickness: 2,
                              dashColor: primaryColor),
                          isSelected: controller.currentIndex.value == 0,
                        ),
                      ),

                      Expanded(
                        child: listingTracker(
                          subTitle: AppStrings.vehicleInfo,
                          child: Dash(
                              direction: Axis.horizontal,
                              length: 27.sp,
                              dashLength: 2,
                              dashThickness: 2,
                              dashColor: primaryColor),
                          isSelected: controller.currentIndex.value == 1,
                        ),
                      ),
                      // CustomPaint(painter: DrawDottedhorizontalline()),

                      Expanded(
                        child: listingTracker(
                          subTitle: AppStrings.documentation,
                          child: Dash(
                              direction: Axis.horizontal,
                              length: 27.sp,
                              dashLength: 2,
                              dashThickness: 2,
                              dashColor: primaryColor),
                          isSelected: controller.currentIndex.value == 2,
                        ),
                      ),
                      // CustomPaint(painter: DrawDottedhorizontalline()),

                      Expanded(
                        child: listingTracker(
                          subTitle: AppStrings.addPhotos,
                          child: Dash(
                              direction: Axis.horizontal,
                              length: 27.sp,
                              dashLength: 2,
                              dashThickness: 2,
                              dashColor: primaryColor),
                          isSelected: controller.currentIndex.value == 3,
                        ),
                      ),
                      Expanded(
                        child: listingTracker(
                          subTitle: AppStrings.availability,
                          child: const Dash(
                              direction: Axis.horizontal,
                              length: 25,
                              dashLength: 4,
                              dashThickness: 2,
                              dashColor: Colors.transparent),
                          isSelected: controller.currentIndex.value == 4,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // stepper widget
                      SizedBox(
                        height: 20.sp,
                      ),
                      // pageview pages
                      SizedBox(
                        height: size.height * 0.9,
                        child: PageView(
                          // itemCount: controller.pages.length,
                          controller: controller.pageController,
                          onPageChanged: (value) {
                            controller.currentIndex.value = value;
                          },
                          // itemBuilder: (context, index) {
                          //   var page = controller.pages[index];
                          //   return page;
                          // },
                          children: <Widget>[
                            // Sender page
                            Container(),
                            // Receiver page
                            Container(),

                            // Package page
                            Container(),

                            //Dispatch page
                            dispatchPage(size),
                            dispatchPage(size),

                            // Add more page widgets for each step
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      // continueButton(),
                    ],
                  )),
                ),
              ],
            ),
          ),
          // }
        ));
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: const Icon(Icons.arrow_back),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.listYourVehicle,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  // dispathc page

  Widget dispatchPage(size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: "dispatch_summary".tr, style: getMediumStyle()),
        SizedBox(height: 15.sp),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200.sp,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                      text: "estimated_total".tr,
                      style:
                          getRegularStyle(fontSize: 14.sp, color: iconColor())
                              .copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 5.sp),
                  textWidget(
                      text: "final_amount_will_be_decided".tr,
                      textOverflow: TextOverflow.visible,
                      style: getLightStyle(fontSize: 11.sp, color: iconColor())
                          .copyWith(fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            textWidget(
                text: "\$40.0",
                style: getRegularStyle(fontSize: 20.sp, color: iconColor())
                    .copyWith(fontWeight: FontWeight.w600))
          ],
        ),
        SizedBox(
          height: 10.sp,
        ),
      ],
    );
  }

  Widget listingTracker({
    required String subTitle,
    Widget? child,
    required bool isSelected,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 0),
              height: 38.sp,
              width: 34.sp,
              padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 7.sp),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : white,
                shape: BoxShape.circle,
                border: Border.all(color: primaryColor),
              ),
              child: Center(
                child: SvgPicture.asset(ImageAssets.toyCar1),
              ),
            ),
            child ?? SizedBox(),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        textWidget(
          text: subTitle,
          style: getLightStyle(fontSize: 8, color: iconColor())
              .copyWith(fontWeight: FontWeight.w400),
        )
      ],
    );
  }

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 50.sp,
            width: 3000.sp,
            text: "continue".tr,
            color: primaryColor,
            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }
}