import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/renter/home/search_city/search_city_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class SearchCityBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SearchCityController>(SearchCityController());
  }
}

class SearchCityScreen extends GetView<SearchCityController> {
  const SearchCityScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: Stack(
            children: [
              body(size, context),
              controller.isFetchingCars.value
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
                  : const SizedBox()
            ],
          )),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
        leading: null,
        hasLeading: false,
        toolbarHeight: 65.sp,
        title: NormalInputTextWidget(
          controller: controller.searchCategoryController,
          hintText: "What City are you in?",
          // labelText: "Email Addres",
          expectedVariable: "field",
          contentPadding: const EdgeInsets.all(10),
          fillColor: white,
          filled: true,
          hintStyle: getLightStyle(color: grey4, fontSize: 12.sp)
              .copyWith(fontWeight: FontWeight.w400),
          prefixIcon: Transform.scale(
            scale: 0.4,
            child: SvgPicture.asset(
              ImageAssets.search,
              height: 18.sp,
              width: 18.sp,
            ),
          ),
          // onChanged: (text) => controller.updateFilteredPages(text),
          title: '',
          // onTap: () => controller.routeToAddressInput(),
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              width: 1.0.w,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0.r),
            ),
          ),
          border: InputBorder.none,
        ),
        titleColor: iconColor(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5, top: 15),
            child: InkWell(
              onTap: controller.selectedType.value == LocationType.city
                  ? controller.resetStateSelection
                  : controller.goBack,
              child: Container(
                height: 65,
                padding: const EdgeInsets.only(
                  right: 10,
                  top: 0,
                ),
                child: Center(
                  child: textWidget(
                      text: controller.selectedType.value == LocationType.city
                          ? AppStrings.reset
                          : AppStrings.cancel,
                      style: getRegularStyle(color: primaryColor)
                          .copyWith(fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          )
        ]);
  }

  Widget body(size, context) {
    return controller.isFetchingStates.value ||
            controller.isFetchingCities.value
        ? centerLoadingIcon()
        : GetBuilder<SearchCityController>(
            init: SearchCityController(),
            initState: (state) {},
            builder: (context) {
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.filteredLocation.isEmpty
                    ? controller.locations.length
                    : controller.filteredLocation.length,
                itemBuilder: (context, index) {
                  var location = controller.filteredLocation.isEmpty
                      ? controller.locations[index]
                      : controller.filteredLocation[index];
                  return InkWell(
                    onTap: () async {
                      controller.selectedStateCode.value = location.code;
                      // controller.selectedState.value = location.name;
                      // controller.locationController.value.text = location.name;

                      if (controller.selectedType.value == LocationType.state) {
                        await controller.getCities();
                        // controller.selectedType.value = LocationType.city;
                        controller.selectedState.value = location.name;
                      } else {
                        controller.selectedCity.value = location.name;
                        controller.onLocationSelected(location);
                        // Handle city selection logic here
                        print("city selected: ");
                        await Get.bottomSheet(
                          StatefulBuilder(builder: (context, setState) {
                            return SizedBox(
                              height: 310.sp,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20.sp,
                                    right: 20.sp,
                                    top: 0.sp,
                                    bottom: 40.sp),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                              onTap: controller.goBack,
                                              child: SvgPicture.asset(
                                                  ImageAssets.dismiss)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      NormalInputTextWidget(
                                        title: AppStrings.location,
                                        expectedVariable: "field",
                                        hintText: "Surulere, Lagos",
                                        readOnly: true,
                                        controller:
                                            controller.locationController.value,
                                      ),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      Form(
                                        key: controller.searchFormKey,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: NormalInputTextWidget(
                                                title: "From",
                                                expectedVariable: "field",
                                                hintText: "1 Nov, 9:00am",
                                                controller: controller
                                                    .fromController.value
                                                  ..text = controller
                                                      .startDateTime.value,
                                                readOnly: true,
                                                fontSize: 12.sp,
                                                onTap: () async {
                                                  // SystemChannels.textInput
                                                  //     .invokeMethod(
                                                  //         'TextInput.hide');
                                                  // controller.routeToSelecteDate();
                                                  var data = await Get.toNamed(
                                                      AppLinks.chooseTripDate,
                                                      arguments: {
                                                        "isRenterHome": true,
                                                        "appBarTitle":
                                                            AppStrings
                                                                .tripDates,
                                                        "from": AppStrings
                                                            .startDate,
                                                        "to":
                                                            AppStrings.endDate,
                                                        "enablePastDates":
                                                            false,
                                                      });
                                                  print(
                                                      "Received data:: $data");
                                                  if (data != null) {
                                                    controller.startDateTime
                                                            .value =
                                                        data['start'] ?? '';
                                                    controller
                                                            .endDateTime.value =
                                                        data['end'] ?? '';
                                                    controller.startDate.value =
                                                        extractDay(controller
                                                            .startDateTime
                                                            .value);
                                                    controller.endDate.value =
                                                        extractDayMonth(
                                                            controller
                                                                .endDateTime
                                                                .value);
                                                    controller
                                                            .selectedDifferenceInDays
                                                            .value =
                                                        data[
                                                            'differenceInDays'];

                                                    WidgetsBinding.instance!
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      setState(() {});
                                                    });
                                                  }
                                                  // print(
                                                  //     "formatted date:: $startDate");
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.sp,
                                            ),
                                            Expanded(
                                              child: NormalInputTextWidget(
                                                title: "To",
                                                expectedVariable: "field",
                                                hintText: "5 Nov, 9:00am",
                                                readOnly: true,
                                                fontSize: 12.sp,
                                                controller: controller
                                                    .toController.value
                                                  ..text = controller
                                                      .endDateTime.value,
                                                onTap: () {
                                                  SystemChannels.textInput
                                                      .invokeMethod(
                                                          'TextInput.hide');
                                                  controller
                                                      .routeToSelecteDate();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.sp,
                                      ),
                                      controller.isFetchingCars.value
                                          ? centerLoadingIcon()
                                          : GtiButton(
                                              text: AppStrings.search,
                                              onTap: () async {
                                                controller.isFetchingCars.value = true;
                                                setState(() {});
                                              await  controller.searchCars();
                                                controller.isFetchingCars.value = false;
                                                setState(() {});
                                              },
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.r),
                                topRight: Radius.circular(6.r)),
                          ),
                        );
                      }

                      print(
                          "selected:: ${controller.locationController.value.text} ");
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(ImageAssets.location),
                        SizedBox(width: 20.w),
                        textWidget(
                          text: location.name,
                          style: getMediumStyle(fontSize: 14.sp, color: grey3)
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ); // Display the widgets from filteredPages
                },
                separatorBuilder: (context, _) => SizedBox(height: 24.h),
              );
            });
  }

  // Widget continueButton() {
  //   return controller.isLoading.isTrue
  //       ? centerLoadingIcon()
  //       : GtiButton(
  //           height: 50.sp,
  //           width: 300.sp,
  //           text: "continue".tr,
  //           color: secondaryColor,
  //           // onTap: controller.routeToPhoneVerification,
  //           isLoading: controller.isLoading.value,
  //         );
  // }
}
