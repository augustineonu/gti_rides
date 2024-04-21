import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/favorite_cars_model.dart';
import 'package:gti_rides/screens/shared_screens/more/favorite/favorite_controller.dart';
import 'package:gti_rides/screens/shared_screens/notification/notification_controller.dart';
import 'package:gti_rides/screens/shared_screens/notification/view_notification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_car_widgets.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ViewNotificationScreen extends GetView<ViewNotificationController> {
  ViewNotificationScreen([Key? key]) : super(key: key);
  final controller = Get.put(ViewNotificationController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        body: Stack(
          children: [
            body(size, context),
          ],
        ));
    // }
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: controller.notificationData!.title ?? 'NAN',
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.sp,
      ).copyWith(top: 20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  text: controller.notificationData!.message ?? 'NAN',
                  textOverflow: TextOverflow.visible,
                  style: getRegularStyle().copyWith(height: 1.8)),
              SizedBox(
                height: 5.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
