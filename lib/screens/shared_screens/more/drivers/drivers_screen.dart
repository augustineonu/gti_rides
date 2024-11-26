import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/drivers/drivers_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/shimmer_loading/box_shimmer.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class DriversScreen extends GetView<DriversController> {
  const DriversScreen([Key? key]) : super(key: key);
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
          text: AppStrings.myDrivers,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context, {required DriversController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Obx(() => controller.obx(
            (state) {
              return Column(
                children: [
                  ListView.builder(
                      itemCount: controller.drivers!.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final driver = controller.drivers![index];
                        return driverCard(controller, driver, index);
                      }),
                  const SizedBox(height: 74),
                  addDriverButton(),
                ],
              );
            },
            onEmpty: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                      child: textWidget(
                          textOverflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          text: AppStrings.noDriversYet,
                          style: getExtraBoldStyle(fontSize: 18.sp))),
                  addDriverButton(),
                ],
              ),
            ),
            onError: (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 50.sp, horizontal: 20),
              child: Center(
                child: Text(
                  "$e",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onLoading: ListView.separated(
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return driverCardShimmer(height: 50.sp);
              },
              separatorBuilder: (_, i) => const SizedBox(
                height: 5,
              ),
            ),
          )),
    );
  }

  Widget driverCard(DriversController controller, driver, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          controller.routeToEditDriver(arguments: {
            "driverID": driver["driverID"],
            "driverEmail": driver["driverEmail"],
            "driverNumber": driver["driverNumber"],
            "fullName": driver["fullName"],
            "userID": driver["userID"]
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 250.sp,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(text: "${index + 1}.", style: getMediumStyle()),
                  SizedBox(
                    width: 6.sp,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                            text: driver['fullName'], style: getMediumStyle()),
                        textWidget(
                            text:
                                "${driver['driverNumber']} | ${driver['driverEmail']}",
                            textOverflow: TextOverflow.visible,
                            style: getRegularStyle(fontSize: 10.sp)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(ImageAssets.pencilPlain)
          ],
        ),
      ),
    );
  }

  Widget addDriverButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 40.sp,
            width: 370,
            text: AppStrings.addDriver,
            hasBorder: true,
            color: backgroundColor,
            borderColor: primaryColor,
            textColor: primaryColor,
            onTap: controller.routeToAddDriver,
            isLoading: controller.isLoading.value,
          );
  }
}
