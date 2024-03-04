import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/favorite_cars_model.dart';
import 'package:gti_rides/screens/shared_screens/more/favorite/favorite_controller.dart';
import 'package:gti_rides/screens/shared_screens/notification/notification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_car_widgets.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ViewNotificationScreen extends GetView<NotificationController> {
  ViewNotificationScreen([Key? key]) : super(key: key);
  final controller = Get.put(NotificationController());
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
          text: 'Your car booking request is approved',
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
                  text:
                      'Whether it\'s a luxurious Rolls Royce for that wedding day, a Mercedes Benz for a movie/photo shoot, a utility vehicle to run errands, an SUV or truck for that interstate trip, ',
                  textOverflow: TextOverflow.visible,
                  style: getRegularStyle().copyWith(height: 1.8)),
                  SizedBox(height: 5.sp,),
              textWidget(
                  text:
                      'GTI Rides* is a peer to peer car sharing app that gives you access to rent from hundreds of car models you won\'t find anywhere else.',
                  
                  textOverflow: TextOverflow.visible,
                  style: getRegularStyle()),
            ],
          ),
        ],
      ),
    );
  }
}
