import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_controller.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/dropdown_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/shared_widgets/upload_image_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/figures_helpers.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiselect/multiselect.dart';

enum Fruit {
  apple,
  banana,
}

class ListVehicleScreenBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ListVehicleController>(ListVehicleController());
  }
}

class ListVehicleScreen extends StatefulWidget {
  const ListVehicleScreen([Key? key]) : super(key: key);

  @override
  State<ListVehicleScreen> createState() => _ListVehicleScreenState();
}

class _ListVehicleScreenState extends State<ListVehicleScreen> {
  final controller = Get.put<ListVehicleController>(ListVehicleController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(() => Scaffold(
          appBar: appBar(controller),
          // body: body(size, context)),
          body: Padding(
            padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 13.sp),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // second retrial
                    // SizedBox(
                    //   height: 30,
                    //   child: Expanded(
                    //     child: ListView.separated(
                    //       itemCount: 5,
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       itemBuilder: (context, index) {
                    //         var current = index + 1;
                    //         return AnimatedContainer(
                    //           duration: const Duration(milliseconds: 300),
                    //           margin: const EdgeInsets.symmetric(horizontal: 0),
                    //           // height: 38.sp,
                    //           // width: 32.sp,
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 5.sp, vertical: 7.sp),
                    //           decoration: BoxDecoration(
                    //             color: white,
                    //             shape: BoxShape.circle,
                    //             border: Border.all(color: primaryColor),
                    //           ),
                    //           child: Center(
                    //             child: Transform.scale(
                    //               scale: 0.6.sp,
                    //               child: SvgPicture.asset(
                    //                 ImageAssets.toyCar1,
                    //                 // width: 33,
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //       separatorBuilder: (context, i) => i == 4
                    //           ? SizedBox.shrink()
                    //           : DottedLine(
                    //               dashLength: 2.5,
                    //               dashGapLength: 2,
                    //               lineThickness: 2.0,
                    //               dashColor: primaryColor,
                    //               lineLength: 22),
                    //     ),
                    //   ),
                    // ),

                    // first trial
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              // height: 38.sp,
                              // width: 32.sp,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 7.sp),
                              decoration: BoxDecoration(
                                color: controller.currentIndex.value == 0
                                    ? primaryColor
                                    : white,
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor),
                              ),
                              child: Center(
                                child: Transform.scale(
                                  scale: 0.6.sp,
                                  child: SvgPicture.asset(
                                    ImageAssets.toyCar1,
                                    // width: 33,
                                  ),
                                ),
                              ),
                            ),
                            DottedLine(
                                dashLength: 2.5,
                                dashGapLength: 2,
                                lineThickness: 2.0,
                                dashColor: primaryColor,
                                lineLength: 22),
                          ],
                        ),
                        // 2
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              // height: 38.sp,
                              // width: 32.sp,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 7.sp),
                              decoration: BoxDecoration(
                                color: controller.currentIndex.value == 1
                                    ? primaryColor
                                    : white,
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor),
                              ),
                              child: Center(
                                child: Transform.scale(
                                  scale: 0.6.sp,
                                  child: SvgPicture.asset(
                                    ImageAssets.toyCar1,
                                    // width: 33,
                                  ),
                                ),
                              ),
                            ),
                            DottedLine(
                                dashLength: 2.5,
                                dashGapLength: 2,
                                lineThickness: 2.0,
                                dashColor: primaryColor,
                                lineLength: 22),
                          ],
                        ),

                        // 3
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              // height: 38.sp,
                              // width: 32.sp,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 7.sp),
                              decoration: BoxDecoration(
                                color: controller.currentIndex.value == 2
                                    ? primaryColor
                                    : white,
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor),
                              ),
                              child: Center(
                                child: Transform.scale(
                                  scale: 0.6.sp,
                                  child: SvgPicture.asset(
                                    ImageAssets.toyCar1,
                                    // width: 33,
                                  ),
                                ),
                              ),
                            ),
                            DottedLine(
                                dashLength: 2.5,
                                dashGapLength: 2,
                                lineThickness: 2.0,
                                dashColor: primaryColor,
                                lineLength: 22),
                          ],
                        ),

                        // 4
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              // height: 38.sp,
                              // width: 32.sp,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 7.sp),
                              decoration: BoxDecoration(
                                color: controller.currentIndex.value == 3
                                    ? primaryColor
                                    : white,
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor),
                              ),
                              child: Center(
                                child: Transform.scale(
                                  scale: 0.6.sp,
                                  child: SvgPicture.asset(
                                    ImageAssets.toyCar1,
                                    // width: 33,
                                  ),
                                ),
                              ),
                            ),
                            DottedLine(
                                dashLength: 2.5,
                                dashGapLength: 2,
                                lineThickness: 2.0,
                                dashColor: primaryColor,
                                lineLength: 22),
                          ],
                        ),

                        // 5
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          // height: 38.sp,
                          // width: 32.sp,
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.sp, vertical: 7.sp),
                          decoration: BoxDecoration(
                            color: controller.currentIndex.value == 4
                                ? primaryColor
                                : white,
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryColor),
                          ),
                          child: Center(
                            child: Transform.scale(
                              scale: 0.6.sp,
                              child: SvgPicture.asset(
                                ImageAssets.toyCar1,
                                // width: 33,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // first trial
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Expanded(
                    //         child: listingTracker(
                    //           subTitle: AppStrings.vehicleType,
                    //           child: Dash(
                    //               direction: Axis.horizontal,
                    //               length: 27.sp,
                    //               dashLength: 2,
                    //               dashThickness: 2,
                    //               dashColor: primaryColor),
                    //           isSelected: controller.currentIndex.value == 0,
                    //         ),
                    //       ),

                    //       Expanded(
                    //         child: listingTracker(
                    //           subTitle: AppStrings.vehicleInfo,
                    //           child: Dash(
                    //               direction: Axis.horizontal,
                    //               length: 27.sp,
                    //               dashLength: 2,
                    //               dashThickness: 2,
                    //               dashColor: primaryColor),
                    //           isSelected: controller.currentIndex.value == 1,
                    //         ),
                    //       ),
                    //       // CustomPaint(painter: DrawDottedhorizontalline()),

                    //       Expanded(
                    //         child: listingTracker(
                    //           subTitle: AppStrings.documentation,
                    //           child: Dash(
                    //               direction: Axis.horizontal,
                    //               length: 28.sp,
                    //               dashLength: 2,
                    //               dashThickness: 2,
                    //               dashColor: primaryColor),
                    //           isSelected: controller.currentIndex.value == 2,
                    //         ),
                    //       ),
                    //       // CustomPaint(painter: DrawDottedhorizontalline()),

                    //       Expanded(
                    //         child: listingTracker(
                    //           subTitle: AppStrings.addPhotos,
                    //           child: Dash(
                    //               direction: Axis.horizontal,
                    //               length: 28.sp,
                    //               dashLength: 2,
                    //               dashThickness: 2,
                    //               dashColor: primaryColor),
                    //           isSelected: controller.currentIndex.value == 3,
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: listingTracker(
                    //           subTitle: AppStrings.availability,
                    //           child: const Dash(
                    //               direction: Axis.horizontal,
                    //               length: 25,
                    //               dashLength: 4,
                    //               dashThickness: 2,
                    //               dashColor: Colors.transparent),
                    //           isSelected: controller.currentIndex.value == 4,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // imageUploadWidget(
                    //   title: AppStrings.uploadVehicleDoc,
                    //   body: AppStrings.pleaseMakeSurePicAreClear,
                    //   onTap: () {},
                    // ),
                    // Flexible(
                    //   fit: FlexFit.tight,
                    //   child: SingleChildScrollView(
                    //       controller: controller.scrollController,
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           // stepper widget
                    //           SizedBox(
                    //             height: 20.sp,
                    //           ),
                    // pageview pages
                    // SizedBox(
                    // height: controller.currentIndex.value == 2
                    //     ? size.height / 0.7
                    //     :
                    // height: size.height / 0.71.sp,
                    // child:

                    SizedBox(
                      height: 20.sp,
                    ),
                    Expanded(
                      child: PageView(
                        // itemCount: controller.pages.length,
                        physics: const ScrollPhysics(),
                        controller: controller.pageController,
                        onPageChanged: (value) {
                          controller.currentIndex.value = value;
                          setState(() {});
                        },
                        children: <Widget>[
                          // Vehicle type page
                          vehicleTypePage(context, controller, size),

                          // vehicle info page
                          vehicleInfoPage(context, controller, size),

                          // Documantation page
                          documentationPage(context, controller, size),

                          //Add photos page
                          addPhotosPage(size, controller),
                          availabilityPage(controller, context, size),
                        ],
                      ),
                    ),
                  ],
                ),
                controller.isFetchingCarDetails.isTrue
                    ? Stack(
                        children: [
                          const Opacity(
                            opacity: 0.5,
                            child: ModalBarrier(
                                dismissible: false, color: Colors.transparent),
                          ),
                          Center(
                            child: Center(child: centerLoadingIcon()),
                          ),
                        ],
                      )
                    : const SizedBox(),
                controller.isGettingyear.isTrue
                    ? Stack(
                        children: [
                          const Opacity(
                            opacity: 0.5,
                            child: ModalBarrier(
                                dismissible: false, color: Colors.transparent),
                          ),
                          Center(
                            child: Center(child: centerLoadingIcon()),
                          ),
                        ],
                      )
                    : const SizedBox(),
                controller.isGettingBrands.isTrue
                    ? Stack(
                        children: [
                          const Opacity(
                            opacity: 0.5,
                            child: ModalBarrier(
                                dismissible: false, color: Colors.transparent),
                          ),
                          Center(
                            child: Center(child: centerLoadingIcon()),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          // }
        ));
  }

  Widget availabilityPage(
      ListVehicleController controller, BuildContext context, Size size) {
    return SizedBox(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: controller.availabilityFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  text: AppStrings.availability,
                  textOverflow: TextOverflow.visible,
                  style: getMediumStyle()),
              SizedBox(
                height: 8.sp,
              ),
              Row(
                children: [
                  Expanded(
                    child: NormalInputTextWidget(
                      title: "From",
                      expectedVariable: "field",
                      hintText: "1 Nov, 9:00am",
                      textColor: controller.startDateTime.value.isEmpty
                          ? grey1
                          : grey5,
                      controller: controller.fromController.value
                        ..text = controller.startDateTime.value,
                      readOnly: true,
                      fontSize: 12.sp,
                      onTap: () async {
                        var data = await Get.toNamed(AppLinks.chooseTripDate,
                            arguments: {
                              "appBarTitle": AppStrings.selectAvailabilityDate,
                              "to": AppStrings.to,
                              "from": AppStrings.from,
                              "rawStartTime": controller.rawStartTime,
                              "rawEndTime": controller.rawEndTime,
                              "isRenterHome": true
                            });

                        // Handle the selected date here
                        print('Selected Date page: $data');
                        if (data != null) {
                          controller.startDateTime.value = data['start'] ?? '';
                          controller.endDateTime.value = data['end'] ?? '';
                          controller.rawStartTime = data['rawStartTime'] ?? '';
                          controller.rawEndTime = data['rawEndTime'] ?? '';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20.sp,
                  ),
                  Expanded(
                    child: NormalInputTextWidget(
                      title: "To",
                      textColor:
                          controller.endDateTime.value.isEmpty ? grey1 : grey5,
                      expectedVariable: "field",
                      hintText: "5 Nov, 9:00am",
                      readOnly: true,
                      fontSize: 12.sp,
                      controller: controller.toController.value
                        ..text = controller.endDateTime.value,
                      onTap: () async {
                        // final data = await controller
                        //     .routeToSelectDate();
                        var data = await Get.toNamed(AppLinks.chooseTripDate,
                            arguments: {
                              "appBarTitle": AppStrings.selectAvailabilityDate,
                              "to": AppStrings.to,
                              "from": AppStrings.from,
                              "rawStartTime": controller.rawStartTime,
                              "rawEndTime": controller.rawEndTime,
                              "isRenterHome": true
                            });

                        // Handle the selected date here
                        if (data != null) {
                          print('Selected Date page: $data');
                          controller.startDateTime.value = data['start'];
                          controller.endDateTime.value = data['end'];
                          controller.rawStartTime = data['rawStartTime'];
                          controller.rawEndTime = data['rawEndTime'];
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.sp,
              ),
              dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  title: AppStrings.howMuchForAdvance,
                  iconColor: grey3,
                  selectedValue: controller.isFromManageCars.isTrue &&
                          controller.advanceTime.value.isNotEmpty
                      ? controller.advanceTime.value.contains('hours')
                          ? controller.advanceTime.value
                          : "4 hours"
                      : null,
                  values: <String>[
                    "4 hours",
                    "12 hours",
                    "24 hours",
                    "48 hours",
                    "72 hours"
                  ],
                  onChange: (value) {
                    print('Selected value: $value');
                    controller.advanceTime.value = value;
                    print("selected day ${controller.advanceTime.value}");
                  }),
              SizedBox(
                height: 24.sp,
              ),
              NormalInputTextWidget(
                expectedVariable: 'field',
                title: AppStrings.proposeRentalRate,
                titleFontSize: 12.sp,
                showCursor: true,
                hintText: AppStrings.amountHintText,
                prefixIcon: Transform.scale(
                    scale: 0.3,
                    child: SvgPicture.asset(
                      ImageAssets.naira,
                      width: 10.sp,
                    )),
                textInputType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  NumberTextInputFormatter(),
                ],
                controller: controller.rentPerDayController,
              ),
              SizedBox(
                height: 7.sp,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.info,
                  ),
                  SizedBox(
                    width: 4.sp,
                  ),
                  textWidget(
                      text:
                          '${AppStrings.standardPrice} ${controller.advisedRenterPrice.value}',
                      style:
                          getMediumStyle(color: primaryColor, fontSize: 10.sp)),
                ],
              ),
              SizedBox(
                height: 24.sp,
              ),
              Row(
                children: [
                  textWidget(
                      text: '${AppStrings.discount} (Optional)',
                      style: getMediumStyle()),
                  SizedBox(
                    width: 4.sp,
                  ),
                  SvgPicture.asset(
                    ImageAssets.info,
                  ),
                  SizedBox(
                    width: 3.sp,
                  ),
                  textWidget(
                      text: AppStrings.learnMore,
                      style:
                          getMediumStyle(color: primaryColor, fontSize: 10.sp)),
                ],
              ),
              SizedBox(
                height: 4.sp,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: dropdownWidget1(
                        context: context,
                        hintText: 'Select',
                        title: AppStrings.chooseNuberOfDays,
                        iconColor: grey3,
                        selectedValue: controller.isFromManageCars.isTrue &&
                                controller.discountDays.isNotEmpty
                            ? controller.discountDays.value
                            : null,
                        values:
                            List.generate(21, (index) => (index).toString()),
                        onChange: (value) {
                          controller.discountDays.value = value;
                          print(
                              'Selected value: $value ${controller.discountDays.value}');
                        },
                        validator: (value) => null),
                  ),
                  SizedBox(width: 20.sp),
                  Expanded(
                    child: NormalInputTextWidget(
                      expectedVariable: 'field',
                      title: "${AppStrings.inputDiscountPerDay} %",
                      titleFontSize: 12.sp,
                      showCursor: false,
                      hintText: '10',
                      controller: controller.discountPerDayController,
                      textInputType: TextInputType.number,
                      validator: (vg) {},
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        // this formatter allows decimal values
                        // FilteringTextInputFormatter.allow(
                        //     RegExp(r'^\d+\.?\d{0,2}')),
                        DiscountInputFormatter(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.sp,
              ),
              textWidget(
                  text: AppStrings.selectDriver,
                  style: getRegularStyle(fontSize: 12.sp)),
              controller.drivers!.isEmpty
                  ? GestureDetector(
                      onTap: () async {
                        noDriverDialog(size, controller)
                            .then((value) => controller.getDrivers());
                      },
                      child: Container(
                        height: 45.h,
                        width: size.width,
                        constraints: BoxConstraints.tightFor(
                            width: size.width.sp, height: 45.sp),
                        // width: size.width,
                        margin: EdgeInsets.symmetric(vertical: 5.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.r),
                          ),
                          border: Border.all(color: grey3),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.sp, vertical: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textWidget(
                                  text: controller.selectedView.value,
                                  style: getRegularStyle(fontSize: 10.sp)),
                              const Icon(
                                Iconsax.arrow_down_1,
                                color: grey3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : PopupMenuButton<Driver>(
                      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      constraints: BoxConstraints.tightFor(
                          width: 320.sp, height: 250.sp),
                      surfaceTintColor: Colors.transparent,
                      color: backgroundColor,
                      onSelected: (value) {},
                      onOpened: () {},
                      itemBuilder: (BuildContext context) {
                        if (controller.drivers?.isNotEmpty == true) {
                          // Set selectedDriverId to the driverId of the first driver
                          controller.selectedDriverId.value =
                              controller.drivers?[0]['driverID'];
                        }

                        return List<PopupMenuEntry<Driver>>.generate(
                          controller.drivers!.length,
                          (int index) {
                            final driver = Driver(
                              fullName: controller.drivers?[index]['fullName'],
                              driverEmail: controller.drivers?[index]
                                  ['driverEmail'],
                              driverId: controller.drivers?[index]['driverID'],
                            );
                            return PopupMenuItem(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              value: driver,
                              child: AnimatedBuilder(
                                animation:
                                    controller.selectedItem.value.reactive,
                                builder: (context, child) {
                                  return RadioListTile<Driver>(
                                    value: driver,
                                    groupValue: controller.selectedItem1.value,
                                    title: child,
                                    onChanged: (Driver? value) {
                                      controller.selectedItem1.value = value!;
                                      controller.selectedView.value =
                                          value.fullName ?? '';
                                      controller.selectedDriverId.value =
                                          driver.driverId!;

                                      Navigator.pop(context);
                                    },
                                    dense: true,
                                    fillColor:
                                        MaterialStateProperty.all(primaryColor),
                                    activeColor: primaryColor,
                                  );
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      textWidget(
                                          text: driver.fullName,
                                          style: getMediumStyle()),
                                      textWidget(
                                          text: driver.driverEmail,
                                          style:
                                              getRegularStyle(fontSize: 10.sp)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        constraints: BoxConstraints.tightFor(
                            width: size.width.sp, height: 45.sp),
                        // width: size.width,
                        margin: EdgeInsets.symmetric(vertical: 5.sp),

                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
                            border: Border.all(color: grey3)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.sp, vertical: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textWidget(
                                  text: controller.selectedView.value,
                                  style: getRegularStyle(fontSize: 10.sp)),
                              const Icon(
                                Iconsax.arrow_down_1,
                                color: grey3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 50.sp,
              ),
              controller.isLoading1.isTrue
                  ? centerLoadingIcon()
                  : GtiButton(
                      onTap: () {
                        controller.addCarAvailability();
                      },
                      text: AppStrings.cont,
                      width: size.width,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> noDriverDialog(Size size, ListVehicleController controller) {
    return Get.dialog(StatefulBuilder(builder: (context, setState) {
      return Dialog(
        child: Container(
          height: size.height * 0.5.sp,
          padding: EdgeInsets.only(
              left: 40.sp, right: 40.sp, bottom: 30.sp, top: 65.sp),
          // height: ,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(
              Radius.circular(12.sp),
            ),
          ),
          child: Column(
            children: [
              SvgPicture.asset(ImageAssets.folder),
              SizedBox(
                height: 40.sp,
              ),
              textWidget(
                text: AppStrings.yetToAddDriver,
                textOverflow: TextOverflow.visible,
                style: getBoldStyle(
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              textWidget(
                text: AppStrings.pleaseAddDriver,
                textOverflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: getRegularStyle(),
              ),
              SizedBox(
                height: 40.sp,
              ),
              GtiButton(
                onTap: () {
                  controller.routeToCreateDriver();
                },
                text: AppStrings.cont,
                width: size.width,
              ),
            ],
          ),
        ),
      );
    }));
  }

  Widget addPhotosPage(Size size, ListVehicleController controller) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.guideForTakingGreatPhotos,
              textOverflow: TextOverflow.visible,
              style: getMediumStyle(fontSize: 14.sp)),
          SizedBox(
            height: 14.sp,
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: controller.cameraInstructions.length,
            itemBuilder: (context, index) {
              var instruction = controller.cameraInstructions[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(ImageAssets.kycCheck),
                  SizedBox(
                    width: 6.sp,
                  ),
                  Expanded(
                    child: textWidget(
                      text: instruction,
                      style: getRegularStyle(fontSize: 12.sp),
                      textOverflow: TextOverflow.visible,
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, _) => SizedBox(
              height: 8.sp,
            ),
          ),
          SizedBox(
            height: 24.sp,
          ),
          photoUploadWithTitle(size,
              richTitle: true,
              title: AppStrings.uploadVehiclePhotos,
              content: AppStrings.uploadDocument, onTap: () {
            if (controller.selectedVehiclePhotos.length +
                    controller.apiFetchedPhotos.length ==
                10) {
              showErrorSnackbar(
                  message: 'You cannot upload more than 10 photos');
            } else {
              selectOptionSheet(size,
                  onSelectCamera: () => controller
                      .openVehiclePhotoCamera()
                      .then((value) => routeService.goBack()),
                  onSelectGallery: () => controller
                      .openVehiclePhotoGallery()
                      .then((value) => routeService.goBack()));
            }
          }),
          SizedBox(
            height: 50.sp,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedVehiclePhotos.length +
                    controller.apiFetchedPhotos.length,
                itemBuilder: (context, index) {
                  if (index < controller.selectedVehiclePhotos.length) {
                    // Display selected photos
                    return Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: imageWidget1(
                        onTap: () =>
                            controller.selectedVehiclePhotos.removeAt(index),
                        localImagePath: controller.selectedVehiclePhotos[index],
                        height: 30.sp,
                        width: 30.sp,
                      ),
                    );
                  } else {
                    // Display fetched photos
                    int fetchedIndex =
                        index - controller.selectedVehiclePhotos.length;
                    return Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: imageWidget1(
                        onTap: () => controller.deleteFetchedPhoto(controller
                            .apiFetchedPhotos[fetchedIndex].photoCode!),
                        networkImagePath:
                            controller.apiFetchedPhotos[fetchedIndex].photoUrl,
                        height: 30.sp,
                        width: 30.sp,
                      ),
                    );
                  }
                }
                // Padding(
                //   padding: const EdgeInsets.only(right: 3.0), // Adjust as needed
                //   child: imageWidget1(
                //     onTap: () => controller.selectedVehiclePhotos.removeAt(index),
                //     localImagePath: controller.selectedVehiclePhotos[index],
                //     height: 30.sp,
                //     width: 30.sp,
                //   ),
                // ),
                ),
          ),
          SizedBox(
            height: 100.sp,
          ),
          controller.isLoading.isTrue
              ? centerLoadingIcon()
              : GtiButton(
                  onTap: () {
                    controller.addCarPhoto();
                  },
                  text: AppStrings.cont,
                  width: size.width,
                ),
        ],
      ),
    );
  }

  Widget photoUploadWithTitle(
    Size size, {
    required String title,
    bool? richTitle = false,
    required String content,
    required void Function()? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: title,
              style: getRegularStyle(fontSize: 12.sp),
              children: <TextSpan>[
                TextSpan(
                  text: richTitle! ? AppStrings.youCanUploadOnly10Photos : '',
                  style: getRegularStyle(fontSize: 12.sp, color: grey3),
                )
              ]),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size.width,
            margin: EdgeInsets.symmetric(vertical: 6.sp),
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 13.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.r)),
                border: Border.all(color: borderColor)),
            child: textWidget(
                text: content,
                textOverflow: TextOverflow.visible,
                style: getRegularStyle(fontSize: 12.sp, color: primaryColor)),
          ),
        ),
      ],
    );
  }

  Widget documentationPage(
      BuildContext context, ListVehicleController controller, Size size) {
    return SizedBox(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: controller.documentationFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              imageUploadWidget(
                title: AppStrings.uploadVehicleDoc,
                body: AppStrings.pleaseMakeSurePicAreClear,
                onTap: () {},
              ),
              SizedBox(
                height: 24.sp,
              ),
              // vehicle license
              photoUploadWithTitle(
                size,
                title: AppStrings.vehicleLicense,
                content: controller.selectedPhotoName.isNotEmpty
                    ? controller.selectedPhotoName.value
                    : AppStrings.uploadDocument,
                onTap: () {
                  selectOptionSheet(size,
                      onSelectCamera: () => controller
                          .openCamera()
                          .then((value) => routeService.goBack()),
                      onSelectGallery: () => controller
                          .openGallery()
                          .then((value) => routeService.goBack()),
                      button1Title: AppStrings.document);
                },
              ),
              const SizedBox(height: 10),
              NormalInputTextWidget(
                titleFontSize: 12,
                title: AppStrings.vehicleLicenseExpiryDate,
                expectedVariable: "field",
                hintText: AppStrings.inputDetails,
                textInputType: TextInputType.none,
                controller: controller.licenseExpiryDateController
                  ..text = controller.licenseExpiryDate.value,
                readOnly: true,
                onTap: () async {
                  var data =
                      await Get.toNamed(AppLinks.chooseTripDate, arguments: {
                    "appBarTitle": AppStrings.selectExpiryDate,
                    "enablePastDates": false,
                    "isSingleDateSelection": true,
                    "isExpiryDateSelection": true
                  });

                  // Handle the selected date here
                  if (kDebugMode) {
                    print('Selected Date page: $data');
                  }
                  if (data != null && data['selectedExpiryDate'] != null) {
                    controller.licenseExpiryDate.value =
                        data['selectedExpiryDate'];
                    print("value ${controller.licenseExpiryDate.value}");
                  }
                },
              ),

              SizedBox(
                height: 24.sp,
              ),
              // road worthiness
              photoUploadWithTitle(size,
                  title: AppStrings.roadWorthiness,
                  content: controller.selectedRoadWorthinessPhotoName.isNotEmpty
                      ? controller.selectedRoadWorthinessPhotoName.value
                      : AppStrings.uploadDocument, onTap: () {
                selectOptionSheet(size,
                    onSelectCamera: () => controller
                        .openRoadWorthinessCamera()
                        .then((value) => routeService.goBack()),
                    onSelectGallery: () => controller
                        .openRoadWorthinessGallery()
                        .then((value) => routeService.goBack()),
                    button1Title: AppStrings.document);
              }),
              const SizedBox(height: 10),
              NormalInputTextWidget(
                titleFontSize: 12,
                title: AppStrings.roadWorthinessExpiryDate,
                expectedVariable: "field",
                hintText: AppStrings.inputDetails,
                textInputType: TextInputType.none,
                controller: controller.roadWorthinessExpiryDateController
                  ..text = controller.roadWorthinessExpiryDate.value,
                readOnly: true,
                onTap: () async {
                  var data =
                      await Get.toNamed(AppLinks.chooseTripDate, arguments: {
                    "appBarTitle": AppStrings.selectExpiryDate,
                    "enablePastDates": false,
                    "isSingleDateSelection": true,
                    "isExpiryDateSelection": true
                  });

                  // Handle the selected date here
                  if (kDebugMode) {
                    print('Selected Date page: $data');
                  }
                  if (data != null && data['selectedExpiryDate'] != null) {
                    controller.roadWorthinessExpiryDate.value =
                        data['selectedExpiryDate'];
                    print("value ${controller.roadWorthinessExpiryDate.value}");
                  }
                },
              ),

              SizedBox(
                height: 24.sp,
              ),
              dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  title: AppStrings.selectInsuranceType,
                  iconColor: grey3,
                  expectedVariable: 'field',
                  values: (controller.insurances?.value ?? [])
                      .map((insurance) => insurance['insuranceName'] as String)
                      .toList(),
                  selectedValue: controller.isFromManageCars.isTrue &&
                          controller.insurance.value.isNotEmpty
                      ? controller.insurance.value
                      : null,
                  onChange: (selectedInsurance) {
                    controller.insurance.value = selectedInsurance;
                    print('Selected value: $selectedInsurance');
                    // Find the brand object with the selected name
                    var selectedObject =
                        (controller.insurances?.value ?? []).firstWhere(
                      (insurance) =>
                          insurance['insuranceName'] == selectedInsurance,
                      orElse: () => null,
                    );
                    if (selectedObject != null) {
                      String insuranceCode =
                          selectedObject['insuranceCode'] as String;
                      controller.insuranceCode.value = insuranceCode;
                      print(
                          "seleted insuranceCode:: ${controller.insuranceCode.value}");
                    }
                  }),

              SizedBox(
                height: 24.sp,
              ),
              // certificate of insurance
              photoUploadWithTitle(size,
                  title: AppStrings.certificateOfInsurance,
                  content: controller.selectedInsurancePhotoName.isNotEmpty
                      ? controller.selectedInsurancePhotoName.value
                      : AppStrings.uploadDocument, onTap: () {
                selectOptionSheet(size,
                    onSelectCamera: () => controller
                        .openInsuranceCamera()
                        .then((value) => routeService.goBack()),
                    onSelectGallery: () => controller
                        .openInsuranceGallery()
                        .then((value) => routeService.goBack()),
                    button1Title: AppStrings.document);
              }),
              const SizedBox(height: 10),
              NormalInputTextWidget(
                titleFontSize: 12,
                title: AppStrings.certificateOfInsuranceExpiryDate,
                expectedVariable: "field",
                hintText: AppStrings.inputDetails,
                textInputType: TextInputType.none,
                controller: controller.insuranceExpiryDateController
                  ..text = controller.insuranceExpiryDate.value,
                readOnly: true,
                onTap: () async {
                  var data =
                      await Get.toNamed(AppLinks.chooseTripDate, arguments: {
                    "appBarTitle": AppStrings.selectExpiryDate,
                    "enablePastDates": false,
                    "isSingleDateSelection": true,
                    "isExpiryDateSelection": true
                  });

                  // Handle the selected date here
                  if (kDebugMode) {
                    print('Selected Date page: $data');
                  }
                  if (data != null && data['selectedExpiryDate'] != null) {
                    controller.insuranceExpiryDate.value =
                        data['selectedExpiryDate'];
                    print("value ${controller.insuranceExpiryDate.value}");
                  }
                },
              ),

              SizedBox(
                height: 24.sp,
              ),
              // vehicle inspection
              photoUploadWithTitle(size,
                  title: AppStrings.vehicleInspectionReport,
                  content: controller.selectedInspectionPhotoName.isNotEmpty
                      ? controller.selectedInspectionPhotoName.value
                      : AppStrings.uploadDocument, onTap: () {
                selectOptionSheet(size,
                    onSelectCamera: () => controller
                        .openInspectionCamera()
                        .then((value) => routeService.goBack()),
                    onSelectGallery: () => controller
                        .openInspectionGallery()
                        .then((value) => routeService.goBack()),
                    button1Title: AppStrings.document);
              }),
              const SizedBox(height: 10),
              NormalInputTextWidget(
                titleFontSize: 12,
                title: AppStrings.vehicleInspectionExpiryDate,
                expectedVariable: "field",
                hintText: AppStrings.inputDetails,
                textInputType: TextInputType.none,
                controller: controller.inspectionExpiryDateController
                  ..text = controller.inspectionExpiryDate.value,
                readOnly: true,
                onTap: () async {
                  var data =
                      await Get.toNamed(AppLinks.chooseTripDate, arguments: {
                    "appBarTitle": AppStrings.selectExpiryDate,
                    "enablePastDates": false,
                    "isSingleDateSelection": true,
                    "isExpiryDateSelection": true
                  });

                  // Handle the selected date here
                  if (kDebugMode) {
                    print('Selected Date page: $data');
                  }
                  if (data != null && data['selectedExpiryDate'] != null) {
                    controller.inspectionExpiryDate.value =
                        data['selectedExpiryDate'];
                    print("value ${controller.inspectionExpiryDate.value}");
                  }
                },
              ),

              SizedBox(
                height: 50.sp,
              ),
              controller.isLoading.isTrue
                  ? centerLoadingIcon()
                  : GtiButton(
                      onTap: () {
                        controller.addCarDocument();
                      },
                      text: AppStrings.cont,
                      width: size.width,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget vehicleInfoPage(
      BuildContext context, ListVehicleController controller, Size size) {
    return SizedBox(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: controller.vehicleInfoFormKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              NormalInputTextWidget(
                  expectedVariable: 'field',
                  title: AppStrings.tellUsAboutYourVehicle,
                  hintText: AppStrings.writeHere,
                  maxLines: 3,
                  maxLength: 300,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100),
                  ],
                  textInputType: TextInputType.text,
                  controller: controller.aboutVehicleController,
                  titleFontSize: 12.sp),
              SizedBox(
                height: 24.sp,
              ),
              dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  expectedVariable: 'field',
                  title: AppStrings.vehicleTransmission,
                  iconColor: grey3,
                  selectedValue: controller.isFromManageCars.isTrue &&
                          controller.transmission.value.isNotEmpty
                      ? controller.transmission.value
                      : null,
                  key: UniqueKey(),
                  values: (controller.transmissions ?? [])
                      .map((transmission) =>
                          transmission['transmissionName'] as String)
                      .toList(),
                  onChange: (selectedTransmission) {
                    controller.transmission.value = selectedTransmission;
                    print('Selected value: $selectedTransmission');
                    print('Selected value1: $selectedTransmission');

                    // Find the brand object with the selected name
                    var selectedObject =
                        (controller.transmissions?.value ?? []).firstWhere(
                      (transmission) =>
                          transmission['transmissionName'] ==
                          selectedTransmission,
                      orElse: () => null,
                    );
                    if (selectedObject != null) {
                      String transmissionCode =
                          selectedObject['transmissionCode'] as String;
                      controller.transmissionCode.value = transmissionCode;
                    }
                  }),
              SizedBox(
                height: 24.sp,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                    text: AppStrings.vehicleFeatures,
                    style: getRegularStyle(fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  ButtonTheme(
                    alignedDropdown: true,
                    child: DropDownMultiSelect<dynamic>(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.sp, vertical: 13.sp),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0.r),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: red,
                              width: 1.0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0.r),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0.r),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: secondaryColor,
                              width: 1.0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0.r),
                            ),
                          ),

                          // filled: true,
                          fillColor: Colors.transparent),
                      onChanged: (List<dynamic> selectedFeatures) {
                        controller.selectedFeatures!.value = selectedFeatures;
                        print("selected $selectedFeatures");

                        // Find the feature objects with the selected names
                        var selectedObjects =
                            (controller.carFeatures?.value ?? [])
                                .where(
                                  (feature) => selectedFeatures
                                      .contains(feature['featuresName']),
                                )
                                .toList();
                        // Extract featuresCode from selected objects
                        List<String> featuresCodes = selectedObjects
                            .map((feature) => feature['featuresCode'] as String)
                            .toList();

                        // Assign the lists to corresponding controller variables
                        controller.featuresCode.value = featuresCodes;
                        print("selectedFeatures: $selectedFeatures");
                        print("featuresCodes: $featuresCodes");
                      },
                      options: (controller.carFeatures?.value ?? [])
                          .map((feature) => feature['featuresName'] as String)
                          .toList(),
                      selectedValues:
                          controller.selectedFeatures!.take(5).toList(),
                      whenEmpty: 'Select',
                      isDense: true,
                      enabled: true,
                      icon: const Icon(
                        Iconsax.arrow_down_1,
                        color: grey3,
                      ),
                    ),
                  ),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     textWidget(
              //       text: AppStrings.vehicleFeatures,
              //       style: getRegularStyle(fontSize: 12.sp),
              //     ),
              //     SizedBox(
              //       height: 5.sp,
              //     ),
              //     DropdownSearch<dynamic>.multiSelection(
              //       clearButtonProps: ClearButtonProps(
              //         color: primaryColor,
              //       ),
              //       items: (controller.carFeatures?.value ?? [])
              //           .map((feature) => feature['featuresName'] as String)
              //           .toList(),
              //       dropdownButtonProps: DropdownButtonProps(
              //         splashColor: primaryColor,
              //         focusColor: primaryColor,
              //         color: primaryColor,
              //         icon: Icon(
              //           Iconsax.arrow_down_1,
              //           color: grey3,
              //         ),
              //       ),
              //       popupProps: PopupPropsMultiSelection.menu(

              //           // selectionWidget: (context, item, isSelected) {

              //           // },
              //           constraints:
              //               BoxConstraints(minHeight: 200.sp, maxHeight: 300.sp),
              //           favoriteItemProps: FavoriteItemProps(),
              //           menuProps: MenuProps(
              //             backgroundColor: backgroundColor,
              //           )
              //           // showSelectedItems: true,

              //           ),

              //       onChanged: (List<dynamic> selectedFeatures) {
              //         controller.selectedFeatures!.value = selectedFeatures;
              //         print("selected $selectedFeatures");

              //         // Find the feature objects with the selected names
              //         var selectedObjects = (controller.carFeatures?.value ?? [])
              //             .where(
              //               (feature) => selectedFeatures
              //                   .contains(feature['featuresName']),
              //             )
              //             .toList();
              //         // Extract featuresCode from selected objects
              //         List<String> featuresCodes = selectedObjects
              //             .map((feature) => feature['featuresCode'] as String)
              //             .toList();

              //         // Assign the lists to corresponding controller variables
              //         controller.featuresCode.value = featuresCodes;
              //         print("selectedFeatures: $selectedFeatures");
              //         print("featuresCodes: $featuresCodes");
              //       },
              //       selectedItems: controller.selectedFeatures!.value,
              //       validator: (selectedItems) {
              //         if (selectedItems == null || selectedItems.isEmpty) {
              //           return "Required field";
              //         } else if (selectedItems.contains("Brazil")) {
              //           return "Invalid item";
              //         } else {
              //           return null; // No error
              //         }
              //       },
              //       dropdownDecoratorProps: DropDownDecoratorProps(
              //         dropdownSearchDecoration: InputDecoration(
              //           iconColor: red, suffixIconColor: red,
              //           contentPadding: EdgeInsets.symmetric(
              //               horizontal: 5.sp, vertical: 7.sp),
              //           enabledBorder: OutlineInputBorder(
              //             borderSide: BorderSide(
              //               color: borderColor,
              //               width: 1.0.w,
              //             ),
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(4.0.r),
              //             ),
              //           ),
              //           errorBorder: OutlineInputBorder(
              //             borderSide: BorderSide(
              //               color: red,
              //               width: 1.0.w,
              //             ),
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(4.0.r),
              //             ),
              //           ),
              //           focusedBorder: OutlineInputBorder(
              //             borderSide: BorderSide(
              //               color: borderColor,
              //               width: 1.0.w,
              //             ),
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(4.0.r),
              //             ),
              //           ),
              //           border: OutlineInputBorder(
              //             borderSide: BorderSide(
              //               color: secondaryColor,
              //               width: 1.0.w,
              //             ),
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(4.0.r),
              //             ),
              //           ),
              //           // decoration: InputDecoration(
              //           //   contentPadding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 13.sp),
              //           //   enabledBorder: OutlineInputBorder(
              //           //     borderSide: BorderSide(
              //           //       color: borderColor,
              //           //       width: 1.0.w,
              //           //     ),
              //           //     borderRadius: BorderRadius.all(
              //           //       Radius.circular(4.0.r),
              //           //     ),
              //           //   ),
              //           //   errorBorder: OutlineInputBorder(
              //           //     borderSide: BorderSide(
              //           //       color: red,
              //           //       width: 1.0.w,
              //           //     ),
              //           //     borderRadius: BorderRadius.all(
              //           //       Radius.circular(4.0.r),
              //           //     ),
              //           //   ),
              //           //   focusedBorder: OutlineInputBorder(
              //           //     borderSide: BorderSide(
              //           //       color: borderColor,
              //           //       width: 1.0.w,
              //           //     ),
              //           //     borderRadius: BorderRadius.all(
              //           //       Radius.circular(4.0.r),
              //           //     ),
              //           //   ),
              //           //   border: OutlineInputBorder(
              //           //     borderSide: BorderSide(
              //           //       color: secondaryColor,
              //           //       width: 1.0.w,
              //           //     ),
              //           //     borderRadius: BorderRadius.all(
              //           //       Radius.circular(4.0.r),
              //           //     ),
              //           //   ),
              //           //   // filled: true,
              //           //   fillColor: Colors.transparent,
              //           // ),
              //           // whenEmpty: 'Select',
              //           // isDense: true,
              //           enabled: true,
              //           // icon: const Icon(
              //           //   Iconsax.arrow_down_1,
              //           //   color: grey3,
              //           // ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 24.sp,
              ),
              dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  title: AppStrings.vehicleType,
                  iconColor: grey3,
                  values: (controller.vehicleTypes?.value ?? [])
                      .map((carType) => carType['typeName'] as String)
                      .toList(),
                  // key: UniqueKey(),
                  selectedValue: controller.isFromManageCars.isTrue &&
                          controller.vehicleType.value.isNotEmpty
                      ? controller.vehicleType.value
                      : null,
                  onChange: (selectedVehicleType) {
                    // controller.vehicleType.value = selectedVehicleType;
                    print('Selected value: $selectedVehicleType');
                    // Find the Vehicle Type object with the selected name
                    var selectedObject =
                        (controller.vehicleTypes?.value ?? []).firstWhere(
                      (vehicleType) =>
                          vehicleType['typeName'] == selectedVehicleType,
                      orElse: () => null,
                    );
                    if (selectedObject != null) {
                      String vehicleTypeCode =
                          selectedObject['typeCode'] as String;
                      controller.vehicleTypeCode.value = vehicleTypeCode;
                      print(
                          "vehicle type code $selectedObject $vehicleTypeCode");
                    }
                  }),
              SizedBox(
                height: 24.sp,
              ),
              dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  title: AppStrings.numberOfSeats,
                  iconColor: grey3,
                  values: (controller.vehicleSeats?.value ?? [])
                      .map((seat) => seat["seatName"] as String)
                      .toList(),
                  selectedValue: controller.isFromManageCars.isTrue &&
                          controller.numberOfSeats.value.isNotEmpty
                      ? controller.numberOfSeats.value
                      : null,
                  onChange: (selectedNoOfSeat) {
                    controller.numberOfSeats.value = selectedNoOfSeat;
                    print('Selected value: $selectedNoOfSeat');

                    // Find the seat Type object with the selected name
                    var selectedObject =
                        (controller.vehicleSeats?.value ?? []).firstWhere(
                      (vehicleSeat) =>
                          vehicleSeat['seatName'] == selectedNoOfSeat,
                      orElse: () => null,
                    );
                    if (selectedObject != null) {
                      String vehicleSeatCode =
                          selectedObject['seatCode'] as String;
                      controller.vehicleSeatCode.value = vehicleSeatCode;
                    }
                  }),
              SizedBox(
                height: 50.sp,
              ),
              controller.isLoading.isTrue
                  ? centerLoadingIcon()
                  : GtiButton(
                      onTap: () {
                        controller.addCarInfo();
                      },
                      text: AppStrings.cont,
                      width: size.width,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget vehicleTypePage(
      BuildContext context, ListVehicleController controller, Size size) {
    return SizedBox(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: controller.vehicleTypeFormKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  title: AppStrings.whatIsTheBrandOfVehicle,
                  iconColor: grey3,
                  expectedVariable: 'field',
                  selectedValue: controller.isFromManageCars.isTrue ||
                          controller.brandName.value.isNotEmpty
                      ? controller.brandName.value
                      : null,
                  // values: controller.vehicleBrands,
                  values: (controller.brands.value.data ?? [])
                      .map((brand) => brand['brandName'] as String)
                      .toList(),
                  onChange: (selectedBrand) async {
                    print('Selected value: $selectedBrand');
                    if (selectedBrand != controller.brandName.value) {
                      controller.selectedBrandModel.value = 'Select';
                      controller.selectedYearValue!.value = 'Select';
                    }
                    controller.brandName.value = selectedBrand;
                    controller.vehicleYear!.clear();
                    controller.vehicleYear!.value = [];
                    controller.selectedValue1 = 'Select';
                    print(
                        "VEHICLE YEAR VALUE:: ${controller.vehicleYear!.value} ${controller.brandName.value}");

                    // Find the brand object with the selected name
                    var selectedBrandObject =
                        (controller.brands.value.data ?? []).firstWhere(
                      (brand) => brand['brandName'] == selectedBrand,
                      orElse: () => null,
                    );
                    if (selectedBrandObject != null) {
                      String brandCode =
                          selectedBrandObject['brandCode'] as String;
                      await controller.getBrandModel(brandCode1: brandCode);
                    }
                  }),
              SizedBox(
                height: 24.sp,
              ),
              Row(
                children: [
                  textWidget(
                      text: "Select brand model",
                      style: getRegularStyle(fontSize: 12.sp)),
                ],
              ),
              if (controller.brandModel!.isEmpty &&
                  controller.selectedBrandModel.value == 'Select')
                GestureDetector(
                  onTap: () {
                    // Handle tap if needed
                  },
                  child: Container(
                    height: 45.h,
                    width: size.width,
                    constraints: BoxConstraints.tightFor(
                      width: size.width.sp,
                      height: 45.sp,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                      border: Border.all(color: grey3),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.sp,
                        vertical: 10.sp,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textWidget(
                            text: controller.selectedBrandModel.value,
                            style: getRegularStyle(fontSize: 10.sp),
                          ),
                          const Icon(
                            Iconsax.arrow_down_1,
                            color: grey3,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    PopupMenuButton<Map<String, dynamic>>(
                      constraints: BoxConstraints(
                        minWidth: 320.sp,
                        maxHeight: 500,
                        minHeight:
                            50.0 + (controller.brandModel?.length ?? 0) * 30,
                      ),
                      // initialValue: ,
                      surfaceTintColor: Colors.transparent,
                      color: backgroundColor,
                      onSelected: (selectedBrand) async {
                        setState(() {
                          // controller.errorMessage!.value = controller
                          //     .validateValue(selectedBrand['modelName'])!;
                          controller.selectedBrandModel.value =
                              selectedBrand['modelName'];
                          controller.modelName?.value =
                              selectedBrand['modelName'];
                          controller.modelCode.value =
                              selectedBrand['modelCode'] as String;
                          controller.brandCode.value =
                              selectedBrand['brandCode'] as String;
                          controller.brandCode1 =
                              selectedBrand['brandCode'] as String;
                          controller.brandModelCode =
                              selectedBrand['modelCode'] as String;
                          print(
                              "Selected brand name: ${controller.modelName?.value}");

                          print("Slected brand code ${controller.brandCode1}");
                        });
                        await controller.getVehicleYear(
                            brandCode: controller.brandCode1!,
                            brandModelCode: controller.brandModelCode!);
                        print(
                            "Slected brand valued ${controller.selectedBrandModel}");
                        var selectedBrandObject =
                            (controller.brandModel ?? []).firstWhere(
                          (brand) => brand['modelName'] == selectedBrand,
                          orElse: () => null,
                        );
                        if (selectedBrandObject != null) {
                          print("object: " + selectedBrandObject);
                        }
                      },
                      onOpened: () {
                        // Handle when the menu is opened if needed
                      },
                      itemBuilder: (BuildContext context) {
                        return List<
                            PopupMenuEntry<Map<String, dynamic>>>.generate(
                          controller.brandModel!.length,
                          (int index) {
                            final brandModel = controller.brandModel![index];

                            return PopupMenuItem<Map<String, dynamic>>(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              value: brandModel,
                              child: textWidget(
                                text: brandModel['modelName'] as String,
                                style: getRegularStyle(),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        constraints: BoxConstraints.tightFor(
                          width: size.width.sp,
                          height: 45.sp,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 5.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                          border: Border.all(color: grey3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 10,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textWidget(
                                text: controller.selectedBrandModel.value,
                                style: getRegularStyle(
                                    fontSize:
                                        controller.selectedBrandModel.value ==
                                                'Select'
                                            ? 10.sp
                                            : 14,
                                    color:
                                        controller.selectedBrandModel.value ==
                                                'Select'
                                            ? borderColor
                                            : black),
                              ),
                              const Icon(
                                Iconsax.arrow_down_1,
                                color: grey3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // if (controller.errorMessage?.value != null)
                    //   Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Text(
                    //       controller.errorMessage!.value,
                    //       style: TextStyle(color: Colors.red),
                    //     ),
                    //   ),
                  ],
                ),
              SizedBox(
                height: 24.sp,
              ),
              Row(
                children: [
                  textWidget(
                      text: AppStrings.whatIsTheModelOfVehicle,
                      style: getRegularStyle(fontSize: 12.sp)),
                ],
              ),
              controller.vehicleYear!.isEmpty &&
                      controller.selectedYearValue!.isEmpty
                  ? GestureDetector(
                      onTap: () {
                        // Handle tap if needed
                      },
                      child: Container(
                        height: 45.h,
                        width: size.width,
                        constraints: BoxConstraints.tightFor(
                          width: size.width.sp,
                          height: 45.sp,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 5.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.r),
                          ),
                          border: Border.all(color: grey3),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.sp,
                            vertical: 10.sp,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textWidget(
                                text: controller.selectedYearValue!.value,
                                style: getRegularStyle(fontSize: 10.sp),
                              ),
                              const Icon(
                                Iconsax.arrow_down_1,
                                color: grey3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : PopupMenuButton<Map<String, dynamic>>(
                      constraints: BoxConstraints(
                        minWidth: 320.sp,
                        maxHeight: 500,
                        minHeight:
                            50.0 + (controller.brandModel?.length ?? 0) * 30,
                      ),
                      surfaceTintColor: Colors.transparent,
                      color: backgroundColor,
                      onSelected: (selectedYear) async {
                        setState(() {
                          controller.selectedYearValue!.value =
                              selectedYear['yearName'];

                          // selectedYear['yearName'] = controller.yearName?.value;
                          controller.yearCode.value = selectedYear['yearCode'];
                          controller.advisedRenterPrice.value =
                              selectedYear['advicePrice'];
                          // Find the brand object with the selected name
                          var selectedYearObject =
                              (controller.vehicleYear ?? []).firstWhere(
                            (year) => year['yearName'] == selectedYear,
                            orElse: () => null,
                          );
                          if (selectedYearObject != null) {
                            String yearCode =
                                selectedYearObject['yearCode'] as String;
                            print("code>>>> $yearCode");
                          }
                        });
                      },
                      onOpened: () {
                        // Handle when the menu is opened if needed
                      },
                      itemBuilder: (BuildContext context) {
                        return List<
                            PopupMenuEntry<Map<String, dynamic>>>.generate(
                          controller.vehicleYear!.length,
                          (int index) {
                            final vehicleYear = controller.vehicleYear![index];

                            return PopupMenuItem<Map<String, dynamic>>(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              value: vehicleYear,
                              child: textWidget(
                                text: vehicleYear['yearName'] as String,
                                style: getRegularStyle(),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        constraints: BoxConstraints.tightFor(
                          width: size.width.sp,
                          height: 45.sp,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 5.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                          border: Border.all(color: grey3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 10,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textWidget(
                                text: controller.selectedYearValue!.value,
                                style: getRegularStyle(
                                    fontSize:
                                        controller.selectedYearValue!.value ==
                                                'Select'
                                            ? 10.sp
                                            : 14,
                                    color:
                                        controller.selectedYearValue!.value ==
                                                'Select'
                                            ? borderColor
                                            : black),
                              ),
                              const Icon(
                                Iconsax.arrow_down_1,
                                color: grey3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 24.sp,
              ),
              NormalInputTextWidget(
                  expectedVariable: 'field',
                  title: AppStrings.whatIsTheVINOfVehicle,
                  hintText: AppStrings.inputVin,
                  textInputType: TextInputType.number,
                  controller: controller.vinController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(17),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  titleFontSize: 12.sp),
              SizedBox(
                height: 24.sp,
              ),
              NormalInputTextWidget(
                  expectedVariable: 'field',
                  title: AppStrings.inputLincesePlateNumber,
                  hintText: AppStrings.inputState,
                  textInputType: TextInputType.text,
                  controller: controller.plateNumberController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(9),
                  ],
                  titleFontSize: 12.sp),
              SizedBox(
                height: 24.sp,
              ),
              dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  title: AppStrings.whatStateAreYouIn,
                  iconColor: grey3,
                  expectedVariable: 'field',
                  selectedValue: controller.isFromManageCars.isTrue ||
                          controller.state.value.isNotEmpty
                      ? controller.state.value
                      : null,
                  values: (controller.states ?? [])
                      .map((state) => state['stateName'] as String)
                      .toList(),
                  onChange: (selectedState) {
                    controller.state.value = selectedState;
                    if (kDebugMode) {
                      print('Selected value: $selectedState');
                    }
                    var selectedStateObject =
                        (controller.states ?? []).firstWhere(
                      (state) => state['stateName'] == selectedState,
                      orElse: () => null,
                    );
                    if (selectedStateObject != null) {
                      String stateCode =
                          selectedStateObject['stateCode'] as String;
                      // String cityCode =
                      //     selectedStateObject['stateCode'] as String;
                      controller.getCity(cityCode1: stateCode);
                      controller.stateCode.value = stateCode;
                      // controller.cityCode.value = cityCode;
                    }
                  }),
              SizedBox(
                height: 24.sp,
              ),
              dropdownWidget1(
                  context: context,
                  hintText: 'Select',
                  title: AppStrings.whatCityAreYouIn,
                  iconColor: grey3,
                  expectedVariable: 'field',
                  selectedValue: controller.isFromManageCars.isTrue ||
                          controller.city.value.isNotEmpty
                      ? controller.city.value
                      : null,
                  values: (controller.cities ?? [])
                      .map((city) => city['cityName'] as String)
                      .toList(),
                  onChange: (selectedCity) {
                    controller.city.value = selectedCity;
                    print('Selected value: $selectedCity');
                    var selectedCityObject =
                        (controller.cities ?? []).firstWhere(
                      (city) => city['cityName'] == selectedCity,
                      orElse: () => null,
                    );
                    if (selectedCityObject != null) {
                      String cityCode =
                          selectedCityObject['cityCode'] as String;
                      controller.cityCode.value = cityCode;
                    }
                  }),
              SizedBox(
                height: 50.sp,
              ),
              controller.isLoading.isTrue
                  ? centerLoadingIcon()
                  : GtiButton(
                      onTap: () {
                        controller.addCar();
                        // controller.pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      },
                      text: AppStrings.cont,
                      width: size.width,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(ListVehicleController controller) {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.listYourVehicle,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  // dispathc page
  Widget listingTracker({
    required String subTitle,
    Widget? child,
    required bool isSelected,
  }) {
    return SizedBox(
      height: 60.sp,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    // height: 38.sp,
                    // width: 32.sp,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.sp, vertical: 7.sp),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : white,
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor),
                    ),
                    child: Center(
                      child: Transform.scale(
                        scale: 0.9.sp,
                        child: SvgPicture.asset(
                          ImageAssets.toyCar1,
                          // width: 33,
                        ),
                      ),
                    ),
                  ),
                ),
                child ?? const SizedBox(),
              ],
            ),
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
      ),
    );
  }

  Future<dynamic> selectOptionSheet(
    Size size, {
    void Function()? onSelectCamera,
    void Function()? onSelectGallery,
    String? button1Title,
  }) {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: 150,
        width: size.width,
        child: Column(
          children: [
            textWidget(text: AppStrings.selectOption, style: getMediumStyle()),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: GtiButton(
                    width: 120.sp,
                    text: AppStrings.camera,
                    onTap: onSelectCamera,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GtiButton(
                    width: 120.sp,
                    text: button1Title ?? AppStrings.gallery,
                    onTap: onSelectGallery,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.r), topRight: Radius.circular(0.r))),
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
