import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/drivers/drivers_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // for (var index = 0; index < controller.drivers!.length; index++)
              ListView.builder(
                  itemCount: controller.drivers!.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    final driver = controller.drivers![index];
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
                                  textWidget(
                                      text: "${index + 1}.",
                                      style: getMediumStyle()),
                                  SizedBox(
                                    width: 6.sp,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textWidget(
                                            text: driver['fullName'],
                                            style: getMediumStyle()),
                                        textWidget(
                                            text:
                                                "${driver['driverNumber']} | ${driver['driverEmail']}",
                                            textOverflow: TextOverflow.visible,
                                            style: getRegularStyle(
                                                fontSize: 10.sp)),
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
                  }),

              const SizedBox(height: 74),
              addDriverButton(),
            ],
          )),
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
