import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/partner/car_history_model.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/view_car/view_car_controller.dart';
import 'package:gti_rides/screens/renter/widgets/car_availability_tag.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remixicon/remixicon.dart';

class ViewCarBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ViewCarController>(ViewCarController());
  }
}

class ViewCarScreen extends GetView<ViewCarController> {
  ViewCarScreen([Key? key]) : super(key: key);
  @override
  final controller = Get.put(ViewCarController());
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
      leading: Transform.scale(
        scale: 0.3,
        child: SvgPicture.asset(
          ImageAssets.close,
          height: 18.sp,
          color: black,
        ),
      ),
      centerTitle: false,
      title: null,
    );
  }

  Widget body(Size size, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // textWidget(text: controller.testString(), style: getMediumStyle()),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              height: 210.sp,
              child: Stack(
                children: [
                  PageView(
                    physics: const BouncingScrollPhysics(),
                    controller: controller.pageController,
                    // controller: PageController(),
                    onPageChanged: (int index) {
                      controller.currentIndex.value = index;
                    },
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (Photo? carPhoto in controller.photoList)
                        if (carPhoto != null)
                          GestureDetector(
                            // onTap: () =>
                            //     controller.routeToViewCar(arguments: {
                            //   "photoList": car?.photo,
                            // }),
                            // would like to add a pinch zoom or so to this feature

                            child: carImage(
                              imgUrl: carPhoto.photoUrl!,
                              height: 210.sp,
                              width: 400.sp,
                              fit: BoxFit.fitWidth,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.r)),
                            ),
                          ),
                    ],
                  ),
                  Positioned(
                      left: 13,
                      bottom: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          if (controller.currentIndex.value > 0) {
                            controller.pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                          print("current index:: ${controller.currentIndex.value}");
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle
                          ),
                          child: Icon(
                            
                            Iconsax.arrow_left_2,
                            color: white,
                            size: 24.sp,
                          ),
                        ),
                      )),
                  Positioned(
                      right: 13,
                      bottom: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          if (controller.currentIndex.value <
                              controller.photoList.length) {
                            controller.pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle
                          ),

                          child: Center(
                            child: Icon(
                              Iconsax.arrow_right_3,
                              color: white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            decoration: BoxDecoration(
              color: grey2,
              borderRadius: BorderRadius.all(
                Radius.circular(2.r),
              ),
            ),
            child: Container(
              width: 50.sp,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                  color: grey2,
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.r),
                  ),
                  border: Border.all(
                    color: white,
                  )),
              child: Center(
                child: textWidget(
                  text:
                      '${controller.currentIndex.value + 1} of ${controller.photoList.length}',
                  style: getLightStyle(fontSize: 10.sp, color: white)
                      .copyWith(fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          height: size.height * 0.02,
        ),
        // continueButton(),
      ],
    );
  }
}
