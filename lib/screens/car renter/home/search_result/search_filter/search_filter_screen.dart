import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/search_filter/search_filter_controller.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/switch_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class SearchFilterBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SearchFilterController>(SearchFilterController());
  }
}

class SearchFilterScreen extends GetView<SearchFilterController> {
  const SearchFilterScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: body(size, context)),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
        onTap: () => controller.goBack(),
        leading: const Icon(Icons.arrow_back),
        centerTitle: false,
        title: textWidget(
            text: AppStrings.filter,
            style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
        titleColor: iconColor(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10),
            child: textWidget(
                text: AppStrings.clearAll,
                style: getRegularStyle(color: primaryColor)
                    .copyWith(fontWeight: FontWeight.w500)),
          )
        ]);
  }

  Widget body(Size size, context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sortBy(
              onTap: () => dialogWidget(
                size,
                alignment: Alignment.topCenter,
                contentHeight: size.height * 0.29,
                title: AppStrings.sortBy,
                content: StatefulBuilder(builder: (context, state) {
                  return ListView.separated(
                    itemCount: controller.sortByList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final sortBy = controller.sortByList[index];
                      return InkWell(
                        onTap: () {
                          controller.onSelectSortBy(index);

                          state(() {
                            controller.selectedSortby.value =
                                !controller.selectedSortby.value;
                          });
                        },
                        child: Row(
                          children: [
                            AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                margin: EdgeInsets.only(right: 10.sp),
                                padding: EdgeInsets.all(3.sp),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(2.r),
                                  border: Border.all(
                                      color:
                                          controller.selectedCheckboxes.value ==
                                                  index
                                              ? primaryColor
                                              : grey3,
                                      width: 1.6),
                                ),
                                child: Container(
                                    padding: EdgeInsets.all(3.sp),
                                    color:
                                        controller.selectedCheckboxes.value ==
                                                index
                                            ? primaryColor
                                            : white)),
                            textWidget(text: sortBy, style: getRegularStyle()),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, _) => SizedBox(height: 14.sp),
                  );
                }),
              ),
            ),
            divider(color: borderColor),
            pricing(),
            divider(color: borderColor),
            driveOptions(context),
            divider(color: borderColor),
            distance(context),
            divider(color: borderColor),
            hostRating(),
            divider(color: borderColor),
            filterOptions(size),
            // textWidget(
            //     text: controller.testString.value, style: getMediumStyle()),

            SizedBox(
              height: size.height * 0.02,
            ),
            // continueButton(),
          ],
        ));
  }

  Widget filterOptions(Size size) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.filterOptionsList.length,
      itemBuilder: (context, index) {
        final filterOptions = controller.filterOptionsList[index];
        return InkWell(
          onTap: () {
            switch (index) {
              case 0:
                // will still need to assign the selected value to the corresponding search options
                featuresSheet(size);
              case 1:
                vehicleType(size);

              case 2:
                // will still need to assign the selected value to the corresponding search options
                vehicleBrandSheet(size);
              case 3:
                vehicleModelSheet(size);
              case 4:
                carSeat(size);
              case 5:
                category(size);
              case 6:
                transmission(size);

              default:
                () {};
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textWidget(
                    text: filterOptions.title,
                    style: getMediumStyle(fontSize: 12.sp, color: grey2)
                        .copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 8,
                ),
                textWidget(
                    text: filterOptions.subTitle,
                    style: getMediumStyle(fontSize: 14.sp)
                        .copyWith(fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (conext, _) => divider(color: borderColor),
    );
  }

  Future<dynamic> vehicleModelSheet(Size size) {
    return Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(19.sp),
        height: size.height * 0.7,
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => controller.goBack(),
                  child: SvgPicture.asset(
                    ImageAssets.close,
                    height: 18.sp,
                    color: black,
                  ),
                ),
                const Spacer(),
                textWidget(
                  text: AppStrings.allBrand,
                  style: getMediumStyle(fontSize: 12.sp)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 35.sp),
                child: Column(
                  children: [
                    StatefulBuilder(
                      builder: (context, state) {
                        return ListView.separated(
                          physics: const ScrollPhysics(),
                          itemCount: controller.vehicleBrands.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final model = controller.vehicleBrands[index];
                            return InkWell(
                              onTap: () {
                                controller.onVehicleModelChecked(index);

                                state(() {
                                  controller.selectedVehicleModel.value =
                                      !controller.selectedVehicleModel.value;
                                });
                              },
                              child: Row(
                                children: [
                                  sqaureCheckBox(
                                      border: Border.all(
                                          color: controller
                                                      .selectedVehicleModels
                                                      .value ==
                                                  index
                                              ? primaryColor
                                              : grey3,
                                          width: 1.6),
                                      color: controller.selectedVehicleModels
                                                  .value ==
                                              index
                                          ? primaryColor
                                          : white),
                                  textWidget(
                                      text: model, style: getRegularStyle()),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, _) =>
                              SizedBox(height: 14.sp),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
      ),
    );
  }

  Future<dynamic> vehicleBrandSheet(Size size) {
    return Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(19.sp),
        height: size.height * 0.7,
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => controller.goBack(),
                  child: SvgPicture.asset(
                    ImageAssets.close,
                    height: 18.sp,
                    color: black,
                  ),
                ),
                const Spacer(),
                textWidget(
                  text: AppStrings.allBrand,
                  style: getMediumStyle(fontSize: 12.sp)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 35.sp),
                child: Column(
                  children: [
                    StatefulBuilder(
                      builder: (context, state) {
                        return ListView.separated(
                          physics: const ScrollPhysics(),
                          itemCount: controller.vehicleBrands.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final brand = controller.vehicleBrands[index];
                            return InkWell(
                              onTap: () {
                                controller.onVehicleBrandChecked(index);

                                state(() {
                                  controller.selectedVehicleBrand.value =
                                      !controller.selectedVehicleBrand.value;
                                });
                              },
                              child: Row(
                                children: [
                                  sqaureCheckBox(
                                      border: Border.all(
                                          color: controller
                                                      .selectedVehicleBrands
                                                      .value ==
                                                  index
                                              ? primaryColor
                                              : grey3,
                                          width: 1.6),
                                      color: controller.selectedVehicleBrands
                                                  .value ==
                                              index
                                          ? primaryColor
                                          : white),
                                  textWidget(
                                      text: brand, style: getRegularStyle()),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, _) =>
                              SizedBox(height: 14.sp),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
      ),
    );
  }

  Future<dynamic> featuresSheet(Size size) {
    return Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(19.sp),
        height: size.height * 0.7,
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => controller.goBack(),
                  child: SvgPicture.asset(
                    ImageAssets.close,
                    height: 18.sp,
                    color: black,
                  ),
                ),
                const Spacer(),
                textWidget(
                  text: AppStrings.features,
                  style: getMediumStyle(fontSize: 12.sp)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 35.sp),
                child: Column(
                  children: [
                    StatefulBuilder(
                      builder: (context, state) {
                        return ListView.separated(
                          physics: ScrollPhysics(),
                          itemCount: controller.features.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final feature = controller.features[index];
                            return InkWell(
                              onTap: () {
                                controller.onCarTypeChecked(index);

                                state(() {
                                  controller.selectedCarType.value =
                                      !controller.selectedCarType.value;
                                });
                              },
                              child: Row(
                                children: [
                                  sqaureCheckBox(
                                      border: Border.all(
                                          color: controller
                                                      .selectedCarTypes.value ==
                                                  index
                                              ? primaryColor
                                              : grey3,
                                          width: 1.6),
                                      color:
                                          controller.selectedCarTypes.value ==
                                                  index
                                              ? primaryColor
                                              : white),
                                  textWidget(
                                      text: feature, style: getRegularStyle()),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, _) =>
                              SizedBox(height: 14.sp),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
      ),
    );
  }

  Future<dynamic> transmission(Size size) {
    final value = controller.selectedTransmissions.value;
    return dialogWidget(
      size,
      contentHeight: size.height * 0.25,
      title: AppStrings.transmission,
      content: StatefulBuilder(builder: (context, state) {
        return ListView.separated(
          itemCount: controller.transmissions.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final transmission = controller.transmissions[index];
            return InkWell(
              onTap: () {
                controller.onTransmissionChecked(index);

                state(() {
                  controller.selectedTransmission.value =
                      !controller.selectedTransmission.value;
                });
              },
              child: Row(
                children: [
                  sqaureCheckBox(
                      border: Border.all(
                          color: controller.selectedTransmissions.value == index
                              ? primaryColor
                              : grey3,
                          width: 1.6),
                      color: controller.selectedTransmissions.value == index
                          ? primaryColor
                          : white),
                  textWidget(text: transmission, style: getRegularStyle()),
                ],
              ),
            );
          },
          separatorBuilder: (context, _) => SizedBox(height: 14.sp),
        );
      }),
    );
  }

  Future<dynamic> category(Size size) {
    return dialogWidget(
      size,
      contentHeight: size.height * 0.52,
      title: AppStrings.category,
      space: 35.sp,
      onTap:  () => controller.goBack(),
      content: StatefulBuilder(builder: (context, state) {
        return ListView.separated(
          itemCount: controller.categories.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return InkWell(
              onTap: () {
                controller.onCategoryChecked(index);

                state(() {
                  controller.selectedCategory.value =
                      !controller.selectedCategory.value;
                });
              },
              child: Row(
                children: [
                  sqaureCheckBox(
                      border: Border.all(
                          color: controller.selectedCategories.value == index
                              ? primaryColor
                              : grey3,
                          width: 1.6),
                      color: controller.selectedCategories.value == index
                          ? primaryColor
                          : white),
                  textWidget(text: category, style: getRegularStyle()),
                ],
              ),
            );
          },
          separatorBuilder: (context, _) => SizedBox(height: 14.sp),
        );
      }),
    );
  }

  Future<dynamic> carSeat(Size size) {
    return dialogWidget(
      size,
      alignment: Alignment.center,
      contentHeight: size.height * 0.44,
      title: AppStrings.vehicleSeat,
      content: StatefulBuilder(builder: (context, state) {
        return ListView.separated(
          itemCount: controller.vehicleSeats.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final vehicleSeat = controller.vehicleSeats[index];
            return InkWell(
              onTap: () {
                controller.onCarSeatChecked(index);

                state(() {
                  controller.selectedCarSeat.value =
                      !controller.selectedCarSeat.value;
                });
              },
              child: Row(
                children: [
                  sqaureCheckBox(
                      border: Border.all(
                          color: controller.selectedCarSeats.value == index
                              ? primaryColor
                              : grey3,
                          width: 1.6),
                      color: controller.selectedCarSeats.value == index
                          ? primaryColor
                          : white),
                  textWidget(text: vehicleSeat, style: getRegularStyle()),
                ],
              ),
            );
          },
          separatorBuilder: (context, _) => SizedBox(height: 14.sp),
        );
      }),
    );
  }

  Future<dynamic> vehicleType(Size size) {
    return dialogWidget(
      size,
      alignment: Alignment.topCenter,
      contentHeight: size.height * 0.44,
      title: AppStrings.vehicleType,
      content: StatefulBuilder(builder: (context, state) {
        return ListView.separated(
          itemCount: controller.carTypes.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final carType = controller.carTypes[index];
            return InkWell(
              onTap: () {
                controller.onCarTypeChecked(index);

                state(() {
                  controller.selectedCarType.value =
                      !controller.selectedCarType.value;
                });
              },
              child: Row(
                children: [
                  sqaureCheckBox(
                      border: Border.all(
                          color: controller.selectedCarTypes.value == index
                              ? primaryColor
                              : grey3,
                          width: 1.6),
                      color: controller.selectedCarTypes.value == index
                          ? primaryColor
                          : white),
                  textWidget(text: carType, style: getRegularStyle()),
                ],
              ),
            );
          },
          separatorBuilder: (context, _) => SizedBox(height: 14.sp),
        );
      }),
    );
  }

 
  Widget hostRating() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          textWidget(
              text: AppStrings.hostRating,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SvgPicture.asset(
                ImageAssets.thumbsUpPrimaryColor,
              ),
              SizedBox(
                width: 5.sp,
              ),
              textWidget(
                  text: '97%',
                  style: getRegularStyle(fontSize: 12.sp)
                      .copyWith(fontFamily: 'Neue')),
            ],
          ),
          SizedBox(
            height: 16.sp,
          ),
          SvgPicture.asset(
            ImageAssets.dividerPin,
          ),
        ],
      ),
    );
  }

  Widget distance(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          textWidget(
              text: AppStrings.distance,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SizedBox(
                width: 260.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                        text: AppStrings.interState, style: getMediumStyle()),
                    textWidget(
                        text: AppStrings.goBeyondState,
                        textOverflow: TextOverflow.visible,
                        style: getMediumStyle(fontSize: 10.sp, color: grey2)),
                  ],
                ),
              ),
              switchWidget(context,
                  value: controller.selectedInterState.value,
                  onChanged: (value) => controller.onSelectInterState(value),
                  activeTrackColor: borderColor),
            ],
          ),
          SizedBox(
            height: 17.sp,
          ),
          Row(
            children: [
              SizedBox(
                width: 260.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                        text: AppStrings.intraState, style: getMediumStyle()),
                    textWidget(
                      text: AppStrings.cannotGoBeyondState,
                      textOverflow: TextOverflow.visible,
                      style: getMediumStyle(fontSize: 10.sp, color: grey2),
                    ),
                  ],
                ),
              ),
              switchWidget(
                context,
                value: controller.selectedIntraState.value,
                onChanged: (value) => controller.onSelectIntraState(value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget driveOptions(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          textWidget(
              text: AppStrings.driveOption,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SizedBox(
                width: 260.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                        text: AppStrings.chauffeur, style: getMediumStyle()),
                    textWidget(
                        text: AppStrings.ourDriverWillSupport,
                        textOverflow: TextOverflow.visible,
                        style: getMediumStyle(fontSize: 10.sp, color: grey2)),
                  ],
                ),
              ),
              switchWidget(context,
                  value: controller.selectedChauffeur.value,
                  onChanged: (value) => controller.onChauffeurSelected(value),
                  activeTrackColor: borderColor),
            ],
          ),
          SizedBox(
            height: 17.sp,
          ),
          Row(
            children: [
              SizedBox(
                width: 260.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                        text: AppStrings.selfDrive, style: getMediumStyle()),
                    textWidget(
                      text: AppStrings.ourDriverWillSupport,
                      textOverflow: TextOverflow.visible,
                      style: getMediumStyle(fontSize: 10.sp, color: grey2),
                    ),
                  ],
                ),
              ),
              switchWidget(
                context,
                value: controller.selectedSelfDrive.value,
                onChanged: (value) => controller.onSelectSelfDrive(value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sortBy({required void Function()? onTap}) {
    final value = controller.selectedCheckboxes.value;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            textWidget(
                text: AppStrings.sortBy,
                style: getMediumStyle(fontSize: 12.sp, color: grey2)
                    .copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 8,
            ),
            textWidget(
                text: value == 0
                    ? AppStrings.relevance
                    : value == 1
                        ? AppStrings.distanceAway
                        : value == 2
                            ? AppStrings.pricePerDayH
                            : AppStrings.pricePerDayL,
                style: getMediumStyle()),
          ],
        ),
      ),
    );
  }

  Widget pricing() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.pricePerDay,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: NormalInputTextWidget(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  prefixIcon: Transform.scale(
                      scale: 0.3,
                      child: SvgPicture.asset(
                        ImageAssets.naira,
                      )),
                  title: AppStrings.from,
                  expectedVariable: "",
                  hintText: '',
                  textInputType: TextInputType.number,
                  controller: controller.fromAmount,
                ),
              ),
              SizedBox(
                width: 15.sp,
              ),
              Expanded(
                child: NormalInputTextWidget(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  prefixIcon: Transform.scale(
                      scale: 0.3,
                      child: SvgPicture.asset(
                        ImageAssets.naira,
                      )),
                  title: AppStrings.to,
                  expectedVariable: "",
                  hintText: '',
                  textInputType: TextInputType.number,
                  controller: controller.toAmount,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 13,
          ),
          SvgPicture.asset(
            ImageAssets.dividerPin,
          ),
        ],
      ),
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
}