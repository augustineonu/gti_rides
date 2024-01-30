import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/renter/home/search_city/search_city_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

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
          body: body(size, context)),
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
          InkWell(
            onTap: controller.goBack,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 15),
              child: textWidget(
                  text: AppStrings.cancel,
                  style: getRegularStyle(color: primaryColor)
                      .copyWith(fontWeight: FontWeight.w400)),
            ),
          )
        ]);
  }

  Widget body(size, context) {
    return controller.isFetchingStates.value
        ? centerLoadingIcon()
        : ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.filteredStates.isEmpty
                ? controller.states.length
                : controller.filteredStates.length,
            itemBuilder: (context, index) {
              var page = controller.filteredStates.isEmpty
                  ? controller.states[index].stateName
                  : controller.filteredStates[index].stateName;
              return InkWell(
                onTap: () async {
                  controller.selectedState.value = page!;
                  controller.locationController.value.text =
                      controller.selectedState.value;

                  print(
                      "selected:: ${controller.locationController.value.text} ");
                },
                child: Row(
                  children: [
                    SvgPicture.asset(ImageAssets.location),
                    SizedBox(width: 20.w),
                    textWidget(
                      text: page,
                      style: getMediumStyle(fontSize: 14.sp, color: grey3)
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ); // Display the widgets from filteredPages
            },
            separatorBuilder: (context, _) => SizedBox(height: 24.h),
          );
  }

  //  await Get.bottomSheet(
  //                   SizedBox(
  //                     height: 310.sp,
  //                     child: Padding(
  //                       padding: EdgeInsets.only(
  //                           left: 20.sp,
  //                           right: 20.sp,
  //                           top: 0.sp,
  //                           bottom: 40.sp),
  //                       child: SingleChildScrollView(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.stretch,
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const SizedBox(height: 20),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 SvgPicture.asset(ImageAssets.dismiss),
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               height: 10.sp,
  //                             ),
  //                             NormalInputTextWidget(
  //                               title: AppStrings.location,
  //                               expectedVariable: "field",
  //                               hintText: "Surulere, Lagos",
  //                               readOnly: true,
  //                               controller: controller.locationController.value,
  //                             ),
  //                             SizedBox(
  //                               height: 10.sp,
  //                             ),
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NormalInputTextWidget(
  //                                     title: "From",
  //                                     expectedVariable: "field",
  //                                     hintText: "1 Nov, 9:00am",
  //                                     controller: controller.fromController,
  //                                     readOnly: true,
  //                                     onTap: () {
  //                                       SystemChannels.textInput
  //                                           .invokeMethod('TextInput.hide');
  //                                       controller.routeToSelecteDate();
  //                                     },
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20.sp,
  //                                 ),
  //                                 Expanded(
  //                                   child: NormalInputTextWidget(
  //                                     title: "To",
  //                                     expectedVariable: "field",
  //                                     hintText: "5 Nov, 9:00am",
  //                                     readOnly: true,
  //                                     controller: controller.toController,
  //                                     onTap: () {
  //                                       SystemChannels.textInput
  //                                           .invokeMethod('TextInput.hide');
  //                                       controller.routeToSelecteDate();
  //                                     },
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               height: 20.sp,
  //                             ),
  //                             GtiButton(
  //                               text: AppStrings.search,
  //                               onTap: () => controller.routeToSearchResult(),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   backgroundColor: Colors.white,
  //                   elevation: 0,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(6.r),
  //                         topRight: Radius.circular(6.r)),
  //                   ),
  //                 );

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
