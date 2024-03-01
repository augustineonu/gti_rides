import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/kyc_check/kyc_check_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class KycCheckBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<KycCheckController>(KycCheckController());
  }
}

class KycCheckScreen extends GetView<KycCheckController> {
  const KycCheckScreen([Key? key]) : super(key: key);
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          textWidget(
              text: controller.isCarListing.value
                  ? AppStrings.gainApprovalCarLIsting
                  : AppStrings.gainApproval,
              textOverflow: TextOverflow.visible,
              style: getMediumStyle(
                fontSize: 22.sp,
              )),
          SizedBox(
            height: 4.sp,
          ),
          textWidget(
              text: AppStrings.kycMessage,
              textOverflow: TextOverflow.visible,
              style: getMediumStyle()),
          SizedBox(
            height: 16.sp,
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: controller.displayKycFields.length,
            itemBuilder: (context, index) {
              final missingKyc = controller.displayKycFields[index];
              return Row(
                children: [
                  SvgPicture.asset(ImageAssets.kycCheck),
                  SizedBox(
                    width: 6.sp,
                  ),
                  textWidget(text: missingKyc, style: getMediumStyle()),
                ],
              );
            },
            separatorBuilder: (context, _) => SizedBox(
              height: 15.sp,
            ),
          ),

          // textWidget(text: controller.testString(), style: getMediumStyle()),
          Spacer(),
          continueButton(),
          SizedBox(
            height: size.height * 0.02,
          ),
          // continueButton(),
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
            color: primaryColor,
            onTap: controller.routeToUpdateKyc,
            isLoading: controller.isLoading.value,
          );
  }
}
