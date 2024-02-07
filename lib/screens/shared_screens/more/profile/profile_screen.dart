import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/profile/profile_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

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
          body: body(size, context, controller)),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: "Profile",
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context, ProfileController controller) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            textWidget(
                text: AppStrings.yourPersonalDetails,
                style: getMediumStyle(fontSize: 24.sp, color: primaryColor)),
            textWidget(
                text: AppStrings.findYourDetails, style: getRegularStyle()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: 78.sp,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(
                            text: AppStrings.displayPicture,
                            style: getRegularStyle()),
                        InkWell(
                          onTap: () {
                            changeImageSheet(size);
                          },
                          child: Stack(
                            children: [
                              profileAvatar(
                                localImagePath:
                                    controller.pickedImagePath.string,
                                imgUrl: controller.user.value.profilePic!,
                                // "https://img.freepik.com/premium-vector/avatar-profile-icon_188544-4755.jpg",
                                height: 65.sp,
                                width: 65.sp,
                                boxHeight: 65.sp,
                                boxWidth: 65.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: SvgPicture.asset(ImageAssets.camera)),
                  ],
                ),
              ),
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: controller.updateFormKey,
              child: Column(
                children: [
                  NormalInputTextWidget(
                    expectedVariable: 'fullName',
                    title: AppStrings.fullName,
                    hintText: AppStrings.fullNameHint,
                    controller: controller.fullNameController,
                    initialValue: controller.user.value.fullName,
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  NormalInputTextWidget(
                    expectedVariable: 'email',
                    title: AppStrings.email,
                    hintText: AppStrings.email,
                    controller: controller.emailController,
                    readOnly: true,
                    textInputType: TextInputType.none,
                    initialValue: controller.user.value.emailAddress,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.08,
            ),
            saveButton(),
          ],
        ));
  }

  Future<dynamic> changeImageSheet(Size size) {
    return Get.bottomSheet(
        Obx(() => Container(
              padding: const EdgeInsets.only(top: 20, bottom: 70),
              width: size.width,
              height: 220.sp,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    imageWidget(
                      imageSizeWidth: 150.sp,
                      imageSizeHeight: 120.sp,
                      radius: 80,
                      imgUrl:
                          "https://img.freepik.com/premium-vector/avatar-profile-icon_188544-4755.jpg",
                      localImagePath: controller.pickedImagePath.value.isNotEmpty
                          ? controller.pickedImagePath.value
                          : null,
                      height: 65.sp,
                      width: 65.sp,
                    ),
                    SizedBox(height: 30.sp,),
                    InkWell(
                      onTap: () {
                        selectOptionSheet(size);
                      },
                      child: textWidget(
                          text: AppStrings.tapToChange,
                          style:
                              getBoldStyle(fontSize: 16.sp, color: primaryColor)),
                    )
                  ],
                ),
              ),
            )),
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.r), topRight: Radius.circular(0.r)),
        ));
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

  Widget saveButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 50.sp,
            width: 300.sp,
            text: AppStrings.saveDetails,
            // color: secondaryColor,
            onTap: controller.updateProfile2,
            isLoading: controller.isLoading.value,
          );
  }
}
