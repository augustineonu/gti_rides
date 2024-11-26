import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/Partner/home/manage_vehicle/manage_vehicle_controller.dart';
import 'package:gti_rides/shared_widgets/generic_car_widgets.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/switch_widget.dart';
import 'package:gti_rides/shared_widgets/tab_indicator.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class ManageVehicleBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ManageVehicleController>(ManageVehicleController());
  }
}

class ManageVehicleScreen extends StatefulWidget {
  ManageVehicleScreen([Key? key]) : super(key: key);

  @override
  State<ManageVehicleScreen> createState() => _ManageVehicleScreenState();
}

class _ManageVehicleScreenState extends State<ManageVehicleScreen> {
  late ManageVehicleController controller = Get.put(ManageVehicleController());
  // final ScrollController scrollController = ScrollController();
  // final ScrollController bookedCarsScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //           scrollController.position.maxScrollExtent &&
    //       !controller.isLoadingMore.value) {
    //     controller.getAllCars(isLoadMore: true);
    //   }
    // });



    controller.bookedCarsScrollController.addListener(() {
      if (controller.bookedCarsScrollController.position.pixels == controller.bookedCarsScrollController.position.maxScrollExtent &&
          !controller.isLoadingMoreBooked.value) {
        controller.getBookedCars(isLoadingMore: true);
      }
    });
    super.initState();
    Get.delete<ManageVehicleController>();

    controller = Get.put(ManageVehicleController());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final controller = Get.find<ManageVehicleController>();
    return Obx(() => Scaffold(
          // appBar: appBar(controller),
          appBar: gtiAppBar(
            onTap: controller.goBack,
            leading: Transform.scale(
                scale: 0.5,
                child: SvgPicture.asset(
                  color: black,
                  ImageAssets.arrowLeft,
                )),
            centerTitle: true,
            title: textWidget(
                text: AppStrings.manageCars,
                style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
            titleColor: iconColor(),
          ),
          // body: body(size, context)),
          body: GetBuilder<ManageVehicleController>(
            init: ManageVehicleController(),
            initState: (_) {},
            builder: (_) {
              return Padding(
                padding:
                    EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 8.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(6.sp),
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(4.r))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tabIndicator(
                            width: 150.sp,
                            title: AppStrings.allCarsSm,
                            selected: controller.selectedIndex.value == 0,
                            onTap: () async {
                              controller.selectedIndex.value = 0;
                              await controller.getAllCars();
                              setState(() {});
                            },
                          ),
                          tabIndicator(
                            width: 150.sp,
                            title: AppStrings.booked,
                            selected: controller.selectedIndex.value == 1,
                            onTap: () async {
                              controller.selectedIndex.value = 1;
                              await controller.getBookedCars();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.sp,
                    ),
                    Expanded(child: buildBody(context, size)),
                    Obx(() {
                      return controller.isLoadingMore.value || controller.isLoadingMoreBooked.value
                          ? Center(
                              child: SizedBox(
                                height: 40.sp,
                              child: centerLoadingIcon(),
                            ))
                          : const SizedBox.shrink();
                    })
                  ],
                ),
              );
            },
          ),
          // }
        ));
  }

  Widget buildBody(context, Size size) {
    switch (controller.selectedIndex.value) {
      case 0:
        return allCars(context, size, controller);
      case 1:
        return bookedCars(context, size);
      default:
        return const SizedBox();
    }
  }

  Widget allCars(
      BuildContext context, Size size, ManageVehicleController controller) {
    return controller.obx(
      (state) {
        return GetBuilder<ManageVehicleController>(
          init: ManageVehicleController(),
          initState: (_) {},
          builder: (_) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    controller: controller.scrollController,
                    itemCount: state!.length,
                    itemBuilder: (context, index) {
                      var car = state[index];
                      return car['status'] == 'pending' ||
                              car['availability'] == "booked" ||
                              car['status'] == "decline"
                          ? bookedOrPendingCars(
                              context,
                              size,
                              car,
                              imgUrl: car['photoUrl'] != ''
                                  ? car['photoUrl']
                                  : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnKpMPFWYvaoInINJ44Qh4weo_z8nDwDUf8Q&usqp=CAU',
                            )
                          : allCarsWidget(context, size, controller, car);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      onEmpty: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(
            child: textWidget(
                text: AppStrings.noListedCarsYet, style: getMediumStyle())),
      ),
      onError: (e) => Padding(
        padding: EdgeInsets.symmetric(
            vertical: context.height * 0.1, horizontal: 20),
        child: Center(
          child: Text(
            "$e",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onLoading: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(child: centerLoadingIcon()),
      ),
    );
  }

  Widget allCarsWidget(BuildContext context, Size size,
      ManageVehicleController controller, car) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        // onTapDown: (TapDownDetails value) {
        //   print("hello");
        //   quickOptionsSheet(size, controller, car);
        // },
        onTap: () => controller.routeToCarHistory(arguments: {
          "brandModelName": car["brandModelName"],
          "photoUrl": car["photoUrl"],
          "carID": car["carID"]
        }),
        child: Stack(
          children: [
            Container(
              height: 140.sp,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: greyLight),
                  borderRadius: BorderRadius.all(Radius.circular(4.r))),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    // color: red,
                    height: size.height,
                    width: 110,
                    child: carImage(
                        imgUrl: car['photoUrl'] != ''
                            ? car['photoUrl']
                            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnKpMPFWYvaoInINJ44Qh4weo_z8nDwDUf8Q&usqp=CAU'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                            text: '${car['brandModelName']}',
                            style: getBoldStyle()),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                    ImageAssets.thumbsUpPrimaryColor),
                                SizedBox(
                                  width: 5.sp,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: '${car['percentageRate']}%',
                                      style: getMediumStyle(
                                        fontSize: 12.sp,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              ' (${car['tripsCount']} trips) ',
                                          style: getLightStyle(
                                              fontSize: 12.sp, color: grey2),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                            Row(
                              // crossAxisAlignment: alignment,
                              children: [
                                SvgPicture.asset(ImageAssets.naira),
                                textWidget(
                                    text: car['pricePerDay'] ?? '0',
                                    // text: 'per day',
                                    style: getMediumStyle(fontSize: 10.sp)
                                        .copyWith(fontFamily: 'Neue')),
                                textWidget(
                                    text: '/day',
                                    style: getMediumStyle(fontSize: 10.sp)
                                        .copyWith(fontFamily: 'Neue')),
                              ],
                            ),
                          ],
                        ),

                        ////////
                        const SizedBox(
                          height: 6,
                        ),

                        textWidget(
                          text: AppStrings.availabilityDate,
                          // show AppStrings.aAvailabilityDate
                          style: getRegularStyle(
                            color: grey3,
                            fontSize: 10.sp,
                          ),
                        ),

                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textWidget(
                                text: car['startDate'] != null
                                    ? formateDate(date: (car['startDate']))
                                    : '',
                                style: getMediumStyle(fontSize: 8.sp)
                                    .copyWith(fontFamily: 'Neue')),
                            SizedBox(
                              width: 3,
                            ),
                            SvgPicture.asset(
                              ImageAssets.arrowForwardRounded,
                              height: 8.sp,
                              width: 8.sp,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            textWidget(
                                text: car['endDate'] != null
                                    ? formateDate(date: car['endDate'])
                                    : '',
                                style: getMediumStyle(fontSize: 8.sp)
                                    .copyWith(fontFamily: 'Neue')),
                          ],
                        ),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 4),
                              decoration: BoxDecoration(
                                  color: car["availability"] == "available"
                                      ? green
                                      : primaryColorLight,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.r))),
                              child: Center(
                                child: textWidget(
                                    text: car['availability'] == 'notAvailable'
                                        ? AppStrings.unavailable
                                        : AppStrings.available,
                                    style: getRegularStyle(fontSize: 10.sp)),
                              ),
                            ),
                            SizedBox(
                              width: 8.sp,
                            ),
                            //
                            switchWidget(
                              context,
                              value: car["availability"] == 'available'
                                  ? true
                                  : false,
                              activeTrackColor: borderColor,
                              onChanged: (value) =>
                                  controller.onToggleCarAvailability(value,
                                      carId: car["carID"]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12.sp,
              top: 12.sp,
              child: InkWell(
                  onTap: () {
                    quickOptionsSheet(size, controller, car);
                  },
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(ImageAssets.popUpMenu))),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> quickOptionsSheet(
      Size size, ManageVehicleController controller, car) {
    return Get.bottomSheet(
      SizedBox(
        height: size.height * 0.2.sp,
        width: size.width.sp,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          itemCount: controller.quickOptions.length,
          itemBuilder: (context, index) {
            final option = controller.quickOptions[index];
            return InkWell(
              onTap: () {
                switch (index) {
                  case 0:
                    deleteVehicleSheet(size,
                        title: AppStrings.areYouSureToDelete
                            .trArgs([car['brandModelName']]),
                        subTitle: AppStrings.everyDataWouldBeDeleted
                            .trArgs([car['brandModelName']]),
                        onTapCancel: controller.goBack,
                        onTapContinue: () =>
                            controller.deleteCar(carID: car['carID']));
                  case 1:
                    controller.routeToQuickEdit(arguments: {
                      "brandModelName": car["brandModelName"],
                      "photoUrl": car["photoUrl"],
                      "carID": car["carID"],
                      "start": car["startDate"],
                      "end": car["endDate"],
                      "enablePastDates": false,
                      "pricePerDay": car["pricePerDay"],
                      "isFromManageCars": true
                    });
                  case 2:
                    controller.routeToListVehicle(arguments: {
                      "carID": car["carID"],
                      "isFromManageCars": true,
                    });
                  case 3:
                    controller.routeToCarHistory(arguments: {
                      "brandModelName": car["brandModelName"],
                      "photoUrl": car["photoUrl"],
                      "carID": car["carID"]
                    });
                    break;
                  default:
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(option['imageUrl']!),
                  const SizedBox(
                    width: 6,
                  ),
                  textWidget(
                      text: option['title'],
                      style: getRegularStyle(color: primaryColor)),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 18,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.r), topRight: Radius.circular(4.r)),
      ),
    );
  }

  Widget bookedOrPendingCars(BuildContext context, Size size, car,
      {required String imgUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => controller.routeToCarHistory(arguments: {
          "brandModelName": car["brandModelName"],
          "photoUrl": car["photoUrl"],
          "carID": car["carID"]
        }),
        // onLongPress: ,
        child: Stack(
          children: [
            Container(
              height: 105,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: greyLight),
                  borderRadius: BorderRadius.all(Radius.circular(4.r))),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        // color: red,
                        height: size.height,
                        width: 110,
                        child: carImage(imgUrl: imgUrl),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        top: 25,
                        bottom: 25,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 4),
                          decoration: BoxDecoration(
                            color: black.withOpacity(0.4),
                            borderRadius: BorderRadius.all(
                              Radius.circular(2.r),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.r),
                                ),
                                border: Border.all(
                                  color: primaryColor,
                                )),
                            child: Center(
                              child: textWidget(
                                text:
                                    'Car status: \n ${car['availability'] == "booked" ? "booked" : car['status']}',
                                textAlign: TextAlign.center,
                                style: getLightStyle(
                                        fontSize: 10.sp, color: primaryColor)
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        // width: 140.sp,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(
                                text: "${car['brandModelName']}",
                                style: getBoldStyle()),
                            const SizedBox(
                              height: 3,
                            ),
                            car['availability'] == 'booked'
                                ? Row(
                                    children: [
                                      SvgPicture.asset(
                                        ImageAssets.naira,
                                        height: 10.sp,
                                      ),
                                      textWidget(
                                          text: car['pricePerDay'] ?? '',
                                          // text: '5,000,000',
                                          style: getMediumStyle(fontSize: 10.sp)
                                              .copyWith(fontFamily: 'Neue'),
                                          textOverflow: TextOverflow.ellipsis),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3, top: 2),
                                        child: SvgPicture.asset(
                                          ImageAssets.closeSmall,
                                          width: 7.sp,
                                          height: 7.sp,
                                        ),
                                      ),
                                      textWidget(
                                          // add the number of days for the trips when returned from the API
                                          // car['numberOfDays']
                                          text: 'day',
                                          style: getMediumStyle(fontSize: 10.sp)
                                              .copyWith(fontFamily: 'Neue')),
                                    ],
                                  )
                                : Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        SvgPicture.asset(
                                          ImageAssets.thumbsUpPrimaryColor,
                                          height: 10.sp,
                                        ),
                                        SizedBox(
                                          width: 3.sp,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: '${car['percentageRate']}%',
                                              style: getMediumStyle(
                                                fontSize: 10.sp,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      ' (${car['tripsCount'] ?? '0'} trips)',
                                                  style: getLightStyle(
                                                      fontSize: 10.sp,
                                                      color: grey2),
                                                )
                                              ]),
                                        )
                                      ]),
                                      SizedBox(
                                        width: 10.sp,
                                      ),
                                      Row(
                                        // crossAxisAlignment: alignment,
                                        children: [
                                          SvgPicture.asset(
                                            ImageAssets.tag,
                                            height: 12.sp,
                                          ),
                                          SizedBox(
                                            width: 2.sp,
                                          ),
                                          SvgPicture.asset(
                                            ImageAssets.naira,
                                            height: 10.sp,
                                          ),
                                          textWidget(
                                              text: car['pricePerDay'] ?? '',
                                              // text: '5,000,000',
                                              style: getMediumStyle(
                                                      fontSize: 10.sp)
                                                  .copyWith(fontFamily: 'Neue'),
                                              textOverflow:
                                                  TextOverflow.ellipsis),
                                          // SvgPicture.asset(
                                          //   ImageAssets.closeSmall,
                                          //   width: 7.sp,
                                          //   height: 7.sp,
                                          // ),
                                          textWidget(
                                              text: '/day',
                                              style: getMediumStyle(
                                                      fontSize: 10.sp)
                                                  .copyWith(
                                                      fontFamily: 'Neue')),
                                        ],
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            textWidget(
                              // text: AppStrings.tripDate,
                              text: car['availability'] != 'booked'
                                  ? AppStrings.availabilityDate
                                  : AppStrings.tripDate,
                              // show AppStrings.aAvailabilityDate
                              style: getRegularStyle(
                                color: grey3,
                                fontSize: 10.sp,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TODO:
                                // add booked star and end date
                                // car['booked'] ? car['bookedStartDate] : car['startDate]
                                textWidget(
                                    text: car['startDate'] != null
                                        ? formateDate(date: car['startDate'])
                                        : '',
                                    style: getMediumStyle(fontSize: 8.sp)
                                        .copyWith(fontFamily: 'Neue')),
                                SizedBox(
                                  width: 3.w,
                                ),
                                SvgPicture.asset(
                                  ImageAssets.arrowForwardRounded,
                                  height: 8.sp,
                                  width: 8.sp,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                textWidget(
                                    text: car['endDate'] != null
                                        ? formateDate(date: car['endDate'])
                                        : '',
                                    style: getMediumStyle(fontSize: 8.sp)
                                        .copyWith(fontFamily: 'Neue')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12.sp,
              top: 12.sp,
              child: InkWell(
                onTap: () {
                  Get.bottomSheet(
                    SizedBox(
                      height: size.height * 0.2.sp,
                      width: size.width.sp,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20),
                        itemCount: controller.quickOptions.length,
                        itemBuilder: (context, index) {
                          final option = controller.quickOptions[index];
                          return InkWell(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  deleteVehicleSheet(size,
                                      title: AppStrings.areYouSureToDelete
                                          .trArgs([car['brandModelName']]),
                                      subTitle: AppStrings
                                          .everyDataWouldBeDeleted
                                          .trArgs([car['brandModelName']]),
                                      onTapCancel: controller.goBack,
                                      onTapContinue: () => controller.deleteCar(
                                          carID: car['carID']));
                                case 1:
                                  controller.routeToQuickEdit(arguments: {
                                    "brandModelName": car["brandModelName"],
                                    "photoUrl": car["photoUrl"],
                                    "carID": car["carID"],
                                    "start": car["startDate"],
                                    "end": car["endDate"],
                                    "enablePastDates": false,
                                    "pricePerDay": car["pricePerDay"],
                                    "isFromManageCars": true
                                  });
                                case 2:
                                  controller.routeToListVehicle(arguments: {
                                    "carID": car["carID"],
                                    "isFromManageCars": true,
                                  });
                                case 3:
                                  controller.routeToCarHistory(arguments: {
                                    "brandModelName": car["brandModelName"],
                                    "photoUrl": car["photoUrl"],
                                    "carID": car["carID"]
                                  });
                                  break;
                                default:
                              }
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(option['imageUrl']!),
                                const SizedBox(
                                  width: 6,
                                ),
                                textWidget(
                                    text: option['title'],
                                    style:
                                        getRegularStyle(color: primaryColor)),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 18,
                        ),
                      ),
                    ),
                    backgroundColor: backgroundColor,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.r),
                          topRight: Radius.circular(4.r)),
                    ),
                  );
                },
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(ImageAssets.popUpMenu),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookedCars(
    BuildContext context,
    Size size,
  ) {
    return controller.obx(
      (state) => state!.where((car) => car['availability'] == 'booked').isEmpty
          ? Center(
              child: textWidget(
                  text: AppStrings.noBookedCarsYet, style: getMediumStyle()))
          : ListView.builder(
              shrinkWrap: true,
              controller: controller.bookedCarsScrollController,
              itemCount:
                  state!.where((car) => car['availability'] == 'booked').length,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                var bookedCars = state
                    .where((car) => car['availability'] == 'booked')
                    .toList();
                var car = bookedCars[index];

                return bookedOrPendingCars(
                  context,
                  size,
                  car,
                  imgUrl: car['photoUrl'] != ''
                      ? car['photoUrl']
                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnKpMPFWYvaoInINJ44Qh4weo_z8nDwDUf8Q&usqp=CAU',
                );
              }),
      onEmpty: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(
            child: textWidget(
                text: AppStrings.noListedCarsYet, style: getMediumStyle())),
      ),
      onError: (e) => Padding(
        padding: EdgeInsets.symmetric(
            vertical: context.height * 0.1, horizontal: 20),
        child: Center(
          child: Text(
            "$e",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onLoading: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(child: centerLoadingIcon()),
      ),
    );
  }

  AppBar appBar(ManageVehicleController controller) {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(
            color: black,
            ImageAssets.arrowLeft,
          )),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.manageCars,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

 

}
