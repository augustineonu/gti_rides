import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/screens/Partner/home/list_vehicle/list_vehicle_controller.dart';
import 'package:gti_rides/shared_widgets/dropdown_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/shared_widgets/upload_image_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
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

class ListVehicleScreen extends GetView<ListVehicleController> {
  const ListVehicleScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put<ListVehicleController>(ListVehicleController());
    return Obx(() => Scaffold(
          appBar: appBar(controller),
          // body: body(size, context)),
          body: Padding(
            padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 13.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0),
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
                              length: 28.sp,
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
                              length: 28.sp,
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

                // imageUploadWidget(
                //   title: AppStrings.uploadVehicleDoc,
                //   body: AppStrings.pleaseMakeSurePicAreClear,
                //   onTap: () {},
                // ),
                Flexible(
                  fit: FlexFit.tight,
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
                        height: size.height * 0.985.sp,
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
                            // Vehicle type page
                            vehicleTypePage(context, controller, size),

                            // vehicle info page
                            vehicleInfoPage(context, controller, size),

                            // Documantation page
                            documentationPage(context, controller, size),

                            //Add photos page
                            addPhotosPage(size),
                            SizedBox(
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
                                          expectedVariable: 'field',
                                          title: AppStrings.from,
                                          showCursor: false,
                                          hintText: AppStrings.dateTimeHintText,
                                        ),
                                      ),
                                      SizedBox(width: 20.sp),
                                      Expanded(
                                        child: NormalInputTextWidget(
                                          expectedVariable: 'field',
                                          title: AppStrings.to,
                                          showCursor: false,
                                          hintText: AppStrings.dateTimeHintText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24.sp,
                                  ),
                                  NormalInputTextWidget(
                                    expectedVariable: 'field',
                                    title: AppStrings.howMuchForAdvance,
                                    titleFontSize: 12.sp,
                                    showCursor: false,
                                    hintText: AppStrings.amountHintText,
                                    textInputType: TextInputType.number,
                                  ),
                                  SizedBox(
                                    height: 24.sp,
                                  ),
                                  NormalInputTextWidget(
                                    expectedVariable: 'field',
                                    title: AppStrings.proposeRentalRate,
                                    titleFontSize: 12.sp,
                                    showCursor: false,
                                    hintText: AppStrings.amountHintText,
                                    prefixIcon: Transform.scale(
                                        scale: 0.3,
                                        child: SvgPicture.asset(
                                          ImageAssets.naira,
                                          width: 10.sp,
                                        )),
                                    textInputType: TextInputType.number,
                                  ),
                                  SizedBox(
                                    height: 24.sp,
                                  ),
                                  Row(
                                    children: [
                                      textWidget(
                                          text: AppStrings.discount,
                                          style: getMediumStyle()),
                                      SizedBox(
                                        width: 4.sp,
                                      ),
                                      SvgPicture.asset(
                                        ImageAssets.info,
                                      ),
                                      SizedBox(
                                        width: 1.5.sp,
                                      ),
                                      textWidget(
                                          text: AppStrings.learnMore,
                                          style: getMediumStyle(
                                              color: primaryColor,
                                              fontSize: 10.sp)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.sp,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: dropdownWidget1(
                                            context: context,
                                            hintText: 'Select',
                                            title: AppStrings.chooseNuberOfDays,
                                            iconColor: grey3,
                                            values: List.generate(
                                                10,
                                                (index) =>
                                                    (index + 1).toString()),
                                            onChange: (value) {
                                              print('Selected value: $value');
                                            }),
                                      ),
                                      SizedBox(width: 20.sp),
                                      Expanded(
                                        child: NormalInputTextWidget(
                                          expectedVariable: 'field',
                                          title: AppStrings.inputDiscountPerDay,
                                          titleFontSize: 12.sp,
                                          showCursor: false,
                                          hintText: AppStrings.amountHintText,
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
                                  // showPopUpMenu(controller, size),
                                  //  InkWell(
                                  //     onTap: () {
                                  //     if (controller.drivers.isEmpty) {
                                  //       print("Please select");
                                  //     }
                                  //   },
                                  //   child: Container(
                                  //     width: 200, height: 100,
                                  //     color: red,
                                  //   )),
                                  InkWell(
                                    onTap: () {
                                      if (controller.drivers.isEmpty) {
                                        print("Please select");
                                      }
                                    },
                                    child: PopupMenuButton<Driver>(
                                      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      constraints: BoxConstraints.tightFor(
                                          width: 320.sp, height: 250.sp),
                                      surfaceTintColor: Colors.transparent,
                                      color: backgroundColor,
                                      onSelected: (value) {},
                                      itemBuilder: (BuildContext context) {
                                        return List<
                                            PopupMenuEntry<Driver>>.generate(
                                          controller.drivers.length,
                                          (int index) {
                                            final driver = Driver(
                                              name: controller.drivers[index]
                                                  ['name'],
                                              details: controller.drivers[index]
                                                  ['details'],
                                            );

                                            return PopupMenuItem(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 0),
                                              value: driver,
                                              child: AnimatedBuilder(
                                                animation: controller
                                                    .selectedItem1
                                                    .value
                                                    .reactive,
                                                builder: (context, child) {
                                                  return RadioListTile<Driver>(
                                                    value: driver,
                                                    groupValue: controller
                                                        .selectedItem1.value,
                                                    title: child,
                                                    onChanged: (Driver? value) {
                                                      controller.selectedItem1
                                                          .value = value!;
                                                      controller.selectedView
                                                          .value = value.name;

                                                      Navigator.pop(context);
                                                    },
                                                    dense: true,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all(primaryColor),
                                                    activeColor: primaryColor,
                                                  );
                                                },
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      textWidget(
                                                          text: driver.name,
                                                          style:
                                                              getMediumStyle()),
                                                      textWidget(
                                                          text: driver.details,
                                                          style:
                                                              getRegularStyle(
                                                                  fontSize:
                                                                      10.sp)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: GestureDetector(
                                        // onTap: () {
                                        //   if (controller.drivers.isEmpty) {
                                        //     if (kDebugMode) {
                                        //       print("No driver found");
                                        //     }
                                        //     noDriverDialog(size);
                                        //   }
                                        // },
                                        child: Container(
                                          constraints: BoxConstraints.tightFor(
                                              width: size.width.sp,
                                              height: 45.sp),
                                          // width: size.width,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5.sp),

                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.r)),
                                              border: Border.all(color: grey3)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.sp,
                                                vertical: 10.sp),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                textWidget(
                                                    text: controller
                                                        .selectedView.value,
                                                    style: getRegularStyle(
                                                        fontSize: 10.sp)),
                                                const Icon(
                                                  Iconsax.arrow_down_1,
                                                  color: grey3,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  dropdownWidget(
                                    context: context,
                                    hintText: 'Select',
                                    title: AppStrings.selectDriver,
                                    iconColor: grey3,
                                    values: List.generate(
                                        controller.drivers.length,
                                        (index) => controller.drivers[index]),
                                    onChange: (value) {
                                      print('Selected value: $value');
                                    },
                                    onTap: () {
                                      if (controller.drivers.isEmpty) {
                                        noDriverDialog(size);
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 50.sp,
                                  ),
                                  GtiButton(
                                    onTap: () {},
                                    text: AppStrings.cont,
                                    width: size.width,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      // continueButto
                    ],
                  )),
                ),
              ],
            ),
          ),
          // }
        ));
  }

  Future<dynamic> noDriverDialog(Size size) {
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
                onTap: () {},
                text: AppStrings.cont,
                width: size.width,
              ),
            ],
          ),
        ),
      );
    }));
  }

  Widget addPhotosPage(Size size) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.howToTakePhoto,
              textOverflow: TextOverflow.visible,
              style: getRegularStyle(fontSize: 12.sp)),
          SizedBox(
            height: 14.sp,
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  SvgPicture.asset(ImageAssets.kycCheck),
                  SizedBox(
                    width: 6.sp,
                  ),
                  textWidget(
                      text: "content 1",
                      style: getRegularStyle(fontSize: 12.sp)),
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
              title: AppStrings.uploadVehiclePhotos,
              content: AppStrings.selectPhotos,
              onTap: () {}),
          SizedBox(
            height: 50.sp,
          ),
          GtiButton(
            onTap: () {},
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
                  text: AppStrings.youCanUploadOnly10Photos,
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
          photoUploadWithTitle(
            size,
            title: AppStrings.vehicleLicense,
            content: AppStrings.uploadDocument,
            onTap: () {
              selectOptionSheet(size);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for(var photo in controller.selectedPhotos)
              imageWidget1(
                radius: 80,
                localImagePath: photo,
                height: 30.sp,
                width: 30.sp,
              ),
            ],
          ),
          SizedBox(
            height: 24.sp,
          ),
          photoUploadWithTitle(size,
              title: AppStrings.roadWorthiness,
              content: AppStrings.uploadDocument,
              onTap: () {}),
          SizedBox(
            height: 24.sp,
          ),
          dropdownWidget1(
              context: context,
              hintText: 'Select',
              title: AppStrings.selectInsuranceType,
              iconColor: grey3,
              values: ['select'],
              onChange: (value) {
                print('Selected value: $value');
              }),
          SizedBox(
            height: 24.sp,
          ),
          photoUploadWithTitle(size,
              title: AppStrings.certificateOfInsurance,
              content: AppStrings.uploadDocument,
              onTap: () {}),
          SizedBox(
            height: 24.sp,
          ),
          photoUploadWithTitle(size,
              title: AppStrings.vehicleInspectionReport,
              content: AppStrings.uploadDocument,
              onTap: () {}),
          SizedBox(
            height: 24.sp,
          ),
          photoUploadWithTitle(size,
              title: AppStrings.uploadVehiclePhotos,
              content: AppStrings.uploadDocument,
              onTap: () {}),
          SizedBox(
            height: 50.sp,
          ),
          GtiButton(
            onTap: () {},
            text: AppStrings.cont,
            width: size.width,
          ),
        ],
      ),
    );
  }

  Widget vehicleInfoPage(
      BuildContext context, ListVehicleController controller, Size size) {
    return SizedBox(
      child: Column(
        children: [
          NormalInputTextWidget(
              expectedVariable: 'field',
              title: AppStrings.tellUsAboutYourVehicle,
              hintText: AppStrings.writeHere,
              maxLines: 3,
              maxLength: 100,
              textInputType: TextInputType.streetAddress,
              titleFontSize: 12.sp),
          SizedBox(
            height: 24.sp,
          ),
          dropdownWidget1(
              context: context,
              hintText: 'Select',
              title: AppStrings.vehicleTransmission,
              iconColor: grey3,
              values: (controller.transmissions ?? [])
                  .map((transmission) =>
                      transmission['transmissionName'] as String)
                  .toList(),
              onChange: (selectedTransmission) {
                print('Selected value: $selectedTransmission');

                // Find the brand object with the selected name
                var selectedObject =
                    (controller.brands.value.data ?? []).firstWhere(
                  (brand) => brand['transmissionName'] == selectedTransmission,
                  orElse: () => null,
                );
                if (selectedObject != null) {
                  String transmissionCode =
                      selectedObject['transmissionCode'] as String;
                  // controller.getVehicleYear(brandCode: transmissionCode);
                  controller.brandCode.value = transmissionCode;
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
                child: DropDownMultiSelect(
                  onChanged: (List<String> value) {
                    controller.selectedFeatures!.value = value;
                  },
                  options: (controller.carFeatures?.value ?? [])
                      .map((feature) => feature['featuresName'] as String)
                      .toList(),
                  selectedValues: controller.selectedFeatures!.value,
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
              onChange: (value) {
                print('Selected value: $value');
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
              onChange: (value) {
                print('Selected value: $value');
              }),
          SizedBox(
            height: 50.sp,
          ),
          GtiButton(
            onTap: () {},
            text: AppStrings.cont,
            width: size.width,
          ),
        ],
      ),
    );
  }

  Widget vehicleTypePage(
      BuildContext context, ListVehicleController controller, Size size) {
    return SizedBox(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: controller.vehicleTypeFormKey,
        child: Column(
          children: [
            dropdownWidget1(
                context: context,
                hintText: 'Select',
                title: AppStrings.whatIsTheBrandOfVehicle,
                iconColor: grey3,
                expectedVariable: 'field',
                // values: controller.vehicleBrands,
                values: (controller.brands.value.data ?? [])
                    .map((brand) => brand['brandName'] as String)
                    .toList(),
                onChange: (selectedBrand) {
                  print('Selected value: $selectedBrand');

                  // Find the brand object with the selected name
                  var selectedBrandObject =
                      (controller.brands.value.data ?? []).firstWhere(
                    (brand) => brand['brandName'] == selectedBrand,
                    orElse: () => null,
                  );
                  if (selectedBrandObject != null) {
                    String brandCode =
                        selectedBrandObject['brandCode'] as String;
                    controller.getVehicleYear(brandCode: brandCode);
                    controller.brandCode.value = brandCode;
                  }
                  // controller.getVehicleYear(brandCode: 'brandCode');
                }),
            SizedBox(
              height: 24.sp,
            ),
            dropdownWidget1(
                context: context,
                hintText: 'Select',
                title: AppStrings.whatIsTheModelOfVehicle,
                iconColor: grey3,
                expectedVariable: 'field',
                values: (controller.vehicleYear ?? [])
                    .map((year) => year['yearName'] as String)
                    .toList(),
                onChange: (selectedYear) {
                  print('Selected value: $selectedYear');
                  controller.yearCode.value = selectedYear;
                  // Find the brand object with the selected name
                  var selectedYearObject =
                      (controller.vehicleYear ?? []).firstWhere(
                    (brand) => brand['yearName'] == selectedYear,
                    orElse: () => null,
                  );
                  if (selectedYearObject != null) {
                    String yearCode = selectedYearObject['yearCode'] as String;
                    controller.yearCode.value = yearCode;
                  }
                }),
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
                values: (controller.states ?? [])
                    .map((state) => state['stateName'] as String)
                    .toList(),
                onChange: (selectedState) {
                  if (kDebugMode) {
                    print('Selected value: $selectedState');
                  }
                  var selectedStateObject =
                      (controller.states ?? []).firstWhere(
                    (brand) => brand['stateName'] == selectedState,
                    orElse: () => null,
                  );
                  if (selectedStateObject != null) {
                    String stateCode =
                        selectedStateObject['stateCode'] as String;
                    controller.getCity(cityCode: stateCode);
                    controller.stateCode.value = stateCode;
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
                values: (controller.cities ?? [])
                    .map((city) => city['cityName'] as String)
                    .toList(),
                onChange: (selectedCity) {
                  print('Selected value: $selectedCity');
                  var selectedCityObject = (controller.cities ?? []).firstWhere(
                    (brand) => brand['cityName'] == selectedCity,
                    orElse: () => null,
                  );
                  if (selectedCityObject != null) {
                    String yearCode = selectedCityObject['cityCode'] as String;
                    controller.yearCode.value = yearCode;
                  }
                }),
            SizedBox(
              height: 50.sp,
            ),
            controller.isLoading.isTrue
                ? centerLoadingIcon()
                : GtiButton(
                    onTap: () {
                      // controller.pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                    text: AppStrings.cont,
                    width: size.width,
                  ),
          ],
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
                      child: SvgPicture.asset(
                        ImageAssets.toyCar1,
                        width: 33,
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

  Future<dynamic> selectOptionSheet(Size size) {
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
                    onTap: () => controller.openCamera(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GtiButton(
                    width: 120.sp,
                    text: AppStrings.gallery,
                    onTap: controller.openGallery,
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