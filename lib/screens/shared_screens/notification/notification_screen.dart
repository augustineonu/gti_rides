import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/favorite_cars_model.dart';
import 'package:gti_rides/screens/shared_screens/more/favorite/favorite_controller.dart';
import 'package:gti_rides/screens/shared_screens/notification/notification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_car_widgets.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/shimmer_loading/box_shimmer.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class NotificationScreen extends GetView<NotificationController> {
  NotificationScreen([Key? key]) : super(key: key);
  final controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(() {
      return Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: RefreshIndicator(
            color: primaryColor,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () {
              return controller.getNotification();
            },
            // onRefresh: () => controller.getFavoriteCars(),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: body(size, context)),
                    controller.isLoadingMore.value
                        ? Center(
                            child: SizedBox(
                            height: 40.sp,
                            child: centerLoadingIcon(),
                          ))
                        : const SizedBox.shrink(),
                  ],
                ),
                controller.isDeletingFavCar.value
                    ? Stack(
                        children: [
                          const Opacity(
                            opacity: 0.5,
                            child: ModalBarrier(
                                dismissible: false, color: Colors.black),
                          ),
                          Center(
                            child: Center(child: centerLoadingIcon()),
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          ));
    });
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
          text: '${AppStrings.notification}s',
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, BuildContext context) {
    return controller.obx(
      (state) {
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 20.sp),
          controller: controller.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: state!.length,
          itemBuilder: (context, index) {
            var notification = state[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.sp,
              ).copyWith(
                top: 20.sp,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                onTap: () {
                  controller.routeToViewNotification(arguments: {
                    "notificationData": notification
                  }).then((value) => notification.status == false
                      ? controller
                          .viewNotification(
                              notificationID: notification.notificationId!)
                          .then((value) => controller.getNotification())
                      : null);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 10.sp,
                            width: 10.sp,
                            padding: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: notification.status == false
                                  ? primaryColor
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          textWidget(
                              text: notification.title,
                              style: getMediumStyle()),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(
                                text: 'Check details',
                                style: getLightStyle(
                                  fontSize: 12.sp,
                                ).copyWith(height: 1.8)),
                            textWidget(
                                text: formatRelativeDateTime(
                                    relative: true,
                                    date: notification.createdAt!),
                                style: getLightStyle(
                                    fontSize: 12.sp, color: grey1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
    );
  }
}
