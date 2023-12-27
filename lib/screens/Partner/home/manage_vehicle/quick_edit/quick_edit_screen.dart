import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/Partner/home/manage_vehicle/quick_edit/quick_edit_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class QuickEditBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<QuickEditController>(QuickEditController());
  }
}

class QuickEditScreen extends GetView<QuickEditController> {
  const QuickEditScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final controller = Get.put<QuickEditController>(QuickEditController());
    return Obx(() => Scaffold(
          appBar: appBar(),
          // body: body(size, context)),
          body: Padding(
            padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 13.sp),
            child: buildBody(context, size),
          ),
          // }
        ));
  }

  Widget buildBody(context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  bottomLeft: Radius.circular(4.r)),
              child: Image.asset(
                'assets/images/fav_car.png',
                fit: BoxFit.fitHeight,
                height: 33.sp,
                width: 51.sp,
              ),
            ),
            textWidget(text: 'Tesla Model Y', style: getBoldStyle()),
          ],
        ),
        SizedBox(
          height: 28.sp,
        ),
        textWidget(text: AppStrings.availabilityDate, style: getMediumStyle()),
        SizedBox(
          height: 8.sp,
        ),
        Row(
          children: [
            Expanded(
              child: NormalInputTextWidget(
                expectedVariable: 'field',
                title: AppStrings.from,
                hintText: AppStrings.dateTimeHintText,
              ),
            ),
            SizedBox(
              width: 20.sp,
            ),
            Expanded(
              child: NormalInputTextWidget(
                expectedVariable: 'field',
                title: AppStrings.to,
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
          prefixIcon: Transform.scale(
            scale: 0.3,
            child: SvgPicture.asset(
              ImageAssets.naira,
            ),
          ),
          title: AppStrings.proposedPricePerDay,
          hintText: AppStrings.amountHintText,
        ),
        SizedBox(
          height: 50.sp,
        ),
        saveButton(),

        /// take out later on
        textWidget(text: controller.testString.value, style: getRegularStyle()),
      ],
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
          text: AppStrings.quickEdit,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget saveButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            text: AppStrings.save,
            color: primaryColor,
            onTap: () {},
            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }
}
