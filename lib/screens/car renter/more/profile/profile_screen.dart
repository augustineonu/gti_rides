import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/more/profile/profile_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ProfileController>(ProfileController());
  }
}

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen([Key? key]) : super(key: key);
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
      onTap: controller.goBack,
      leading: const Icon(Icons.arrow_back),
      centerTitle: true,
      title: textWidget(
          text: "Profile",
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(size, context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(
                text: AppStrings.yourPersonalDetails,
                style: getMediumStyle(fontSize: 24.sp, color: primaryColor)),
            textWidget(
                text: AppStrings.findYourDetails, style: getRegularStyle()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                onTap: () {
                  print("Press");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget(
                        text: AppStrings.displayPicture,
                        style: getRegularStyle()),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                            Container(
                              padding: EdgeInsets.only(top: 20, bottom: 70),
                              width: size.width,
                              height: 220.sp,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    child: Image.asset(
                                        'assets/images/default_profile_image.png'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                         
                                          height: 150,
                                          width: size.width,
                                          child: Column(
                                            children: [
                                              textWidget(
                                                  text: AppStrings.selectOption,
                                                  style: getMediumStyle()),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: GtiButton(
                                                      width: 120.sp,
                                                      text: AppStrings.camera,
                                                      onTap:  ()=> controller.openCamera(),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: GtiButton(
                                                      width: 120.sp,
                                                      text: AppStrings.gallery,
                                                      onTap: () {},
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
                                                topLeft: Radius.circular(0.r),
                                                topRight:
                                                    Radius.circular(0.r))),
                                      );
                                    },
                                    child: textWidget(
                                        text: AppStrings.tapToChange,
                                        style: getBoldStyle(
                                            fontSize: 16.sp,
                                            color: primaryColor)),
                                  )
                                ],
                              ),
                            ),
                            backgroundColor: white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0.r),
                                  topRight: Radius.circular(0.r)),
                            ));
                      },
                      child: Stack(
                        children: [
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: SvgPicture.asset(
                                'assets/svg/camera_plus.svg',
                                width: 21.sp,
                                height: 21.sp,
                              )),
                          Transform.scale(
                            scale: 1.5,
                            child: imageAvatar(
                                imgUrl:
                                    "https://img.freepik.com/premium-vector/avatar-profile-icon_188544-4755.jpg",
                                height: 38.sp,
                                width: 34.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NormalInputTextWidget(
              expectedVariable: 'fullName',
              title: AppStrings.fullName,
              hintText: AppStrings.fullNameHint,
              controller: controller.fullNameController,
            ),
            SizedBox(
              height: 20.sp,
            ),
            NormalInputTextWidget(
              expectedVariable: 'email',
              title: AppStrings.email,
              hintText: AppStrings.email,
              controller: controller.emailController,
            ),
            SizedBox(
              height: size.height * 0.08,
            ),
            saveButton(),
          ],
        ));
  }

  Widget saveButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 50.sp,
            width: 300.sp,
            text: AppStrings.saveDetails,
            // color: secondaryColor,
            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }
}
