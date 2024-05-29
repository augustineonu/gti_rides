import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/manage_vehicle/car_history/car_history_controller.dart';
import 'package:gti_rides/shared_widgets/generic_car_widgets.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:iconsax/iconsax.dart';

class CarHistoryBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CarHistoryController>(CarHistoryController());
  }
}

class CarHistoryScreen extends StatelessWidget {
  CarHistoryScreen([Key? key]) : super(key: key);
  final controller = Get.put(CarHistoryController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(controller),
        body: controller.obx(
          (state) {
            return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    carImage(
                        imgUrl: controller.photoUrl.value.isNotEmpty
                            ? controller.photoUrl.value
                            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnKpMPFWYvaoInINJ44Qh4weo_z8nDwDUf8Q&usqp=CAU',
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        height: 103.h,
                        width: size.width),
                    SizedBox(height: 15.sp),
                    // change this when the data is returned from the API
                    tripsAndRating(
                      tripCount: state![0]['tripsCount'].toString() ?? '0',
                      rating: state[0]['percentage'].toString() ?? '0',
                    ),
                    SizedBox(height: 12.sp),
                    divider(color: borderColor),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textWidget(
                              text: "Car ID:",
                              style:
                                  getRegularStyle(fontSize: 12.sp, color: grey5)
                                      .copyWith(fontFamily: 'Neue')),
                          InkWell(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                            onTap: () => controller.copy(
                                value: state[0]["carID"].toString()),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: textWidget(
                                  text: state[0]["carID"].toString(),
                                  style: getMediumStyle(color: primaryColor)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    divider(color: borderColor),

                    seeAllFeedbacks(
                        feedbackCount:
                            state[0]['feedbackCount'].toString() ?? "not set"),
                    divider(color: borderColor),
                    earningsAndAllTrips(
                      totalEarnings: state[0]['totalEarning'].toString() ?? '',
                    ),
                    divider(color: borderColor),
                    tripDate(
                      title: AppStrings.availabilityDate,
                      startDate: formateDate(date: state[0]['startDate'] ?? ''),
                      endDate: formateDate(date: state[0]['endDate'] ?? ''),
                      trailling: InkWell(
                        onTap: () async {
                          controller.routeToQuickEdit();
                          // var result = await Get.toNamed(AppLinks.quickEdit, arguments: {
                          //     "startDate": controller.startDate.value,
                          //     "endDate": controller.endDate.value,
                          //     "pricePerDay": controller.pricePerDay.value,
                          //     "brandModelName": controller.brandModelName.value,
                          //     "photoUrl": controller.photoUrl.value,
                          //     "carID": controller.carID.value,
                          //   });
                          // if (result != null) {
                          //   Get.put(CarHistoryController());
                          // }
                        },
                        child: Row(
                          children: [
                            textWidget(
                                text: AppStrings.quickEdit,
                                style: getMediumStyle(
                                    fontSize: 12.sp, color: primaryColor)),
                            SizedBox(
                              width: 6.sp,
                            ),
                            SvgPicture.asset(ImageAssets.pencilEdit),
                          ],
                        ),
                      ),
                    ),
                    divider(color: borderColor),
                    carBasics(
                      carType: state[0]['type'].isNotEmpty == true
                          ? state[0]['type'][0]['typeName'] ?? ''
                          : '',
                      carSeat: state[0]['seat']?.isNotEmpty == true
                          ? state[0]['seat'][0]['seatName'] ?? ''
                          : '',
                    ),
                    divider(color: borderColor),
                    carFetures(children: [
                      for (var feature in state[0]['feature'] ?? [])
                        chipWidget(title: feature['featuresName'] ?? '')
                    ]),

                    divider(color: borderColor),
                    transmission(
                      transmission: state.isNotEmpty &&
                              state[0]['transmission']?.isNotEmpty == true
                          ? state[0]['transmission']![0]['transmissionName'] ??
                              ''
                          : '',
                    ),
                    divider(color: borderColor),
                    aboutCar(aboutCar: state[0]['about'] ?? ''),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    // continueButton(),
                  ],
                ));
          },
          onEmpty: Padding(
            padding: EdgeInsets.symmetric(vertical: context.height * 0.3),
            child: const Center(child: Text("Data is Empty")),
          ),
          onError: (e) => Padding(
            padding: EdgeInsets.symmetric(
                vertical: context.height * 0.3, horizontal: 20),
            child: Center(
              child: Text(
                "exception $e",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          onLoading: Padding(
            padding: EdgeInsets.symmetric(vertical: context.height * 0.3),
            child: Center(child: centerLoadingIcon()),
          ),
        ),
      ),
      // }
    );
  }

  Widget earningsAndAllTrips({required String totalEarnings}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  text: AppStrings.totalEarnings,
                  style: getRegularStyle(fontSize: 12.sp, color: grey5)
                      .copyWith(fontFamily: 'Neue')),
              SizedBox(
                height: 5.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: SvgPicture.asset(ImageAssets.naira),
                  ),
                  SizedBox(
                    width: 2.sp,
                  ),
                  textWidget(
                    text: totalEarnings,
                    style: getMediumStyle().copyWith(
                      fontFamily: 'Neue',
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: controller.routeToOwnerTrips,
            child: Row(
              children: [
                textWidget(
                    text: AppStrings.seeAllTrips,
                    style:
                        getRegularStyle(fontSize: 10.sp, color: primaryColor)),
                SizedBox(
                  width: 5.sp,
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: primaryColor,
                  size: 12.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget seeAllFeedbacks({
    required String feedbackCount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              textWidget(
                  text: AppStrings.feedbacks,
                  style: getRegularStyle(fontSize: 12.sp, color: grey5)
                      .copyWith(fontFamily: 'Neue')),
              SizedBox(
                height: 5.sp,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.thumbsUpPrimaryColor,
                    color: secondaryColor,
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  textWidget(
                      text: '($feedbackCount)',
                      style: getRegularStyle(fontSize: 12.sp, color: grey2)),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: controller.routeToFeedbacks,
            child: Row(
              children: [
                textWidget(
                    text: AppStrings.seeAllFeedbacks,
                    style:
                        getRegularStyle(fontSize: 10.sp, color: primaryColor)),
                SizedBox(
                  width: 5.sp,
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: primaryColor,
                  size: 12.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tripsAndRating({
    required String tripCount,
    required String rating,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(
                text: tripCount,
                style: getRegularStyle(fontSize: 24.sp, color: primaryColor)),
            textWidget(
                text: AppStrings.trips,
                style: getRegularStyle(
                  fontSize: 10.sp,
                )),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(
                text: '$rating%',
                style: getRegularStyle(fontSize: 24.sp, color: primaryColor)),
            textWidget(
                text: AppStrings.carRating,
                style: getRegularStyle(
                  fontSize: 10.sp,
                )),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 50.sp,
            width: 300.sp,
            text: "continue".tr,
            color: secondaryColor,
            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }

  AppBar appBar(CarHistoryController controller) {
    return gtiAppBar(
      onTap: () => controller.goBack(),
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(
            color: black,
            ImageAssets.arrowLeft,
          )),
      centerTitle: true,
      title: textWidget(
          text: controller.brandModelName.value,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
    );
  }
}
