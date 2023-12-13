import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/inbox/inbox_controller.dart';
import 'package:gti_rides/screens/shared_screens/more/more_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/helpers.dart';

class InboxBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<InboxController>(InboxController());
  }
}

class InboxScreen extends StatelessWidget {
  const InboxScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ctrl = Get.put<InboxController>(InboxController());

    return Scaffold(
      appBar: customAppBar(width, ctrl),
      body: body(width),
    );
  }

  Widget body(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          faqWidget(width),
        ],
      ),
    );
  }

  Widget faqWidget(double width) {
    return Column(
      children: [
        Container(
          width: width,
          height: 2.sp,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2.r),
                topRight: Radius.circular(2.r),
              )),
        ),
        Container(
          width: width.sp,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.all(
                Radius.circular(4.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.1),
                  offset: Offset(0.0, 5.0), //(x,y)
                  blurRadius: 4.0,
                ),
              ]),
          padding: EdgeInsets.all(18.sp),
          child: InkWell(
            onTap: () {},
            child: Container(
              width: width.sp,
              decoration: BoxDecoration(
                color: primaryColorLight,
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
              ),
              padding: EdgeInsets.all(10.sp),
              child: Row(
                children: [
                  SvgPicture.asset(ImageAssets.chat),
                  SizedBox(
                    width: 4.sp,
                  ),
                  Expanded(
                    child: textWidget(
                        text: AppStrings.findAnswersToFAQ,
                        textOverflow: TextOverflow.visible,
                        style: getLightStyle(fontSize: 12.sp)),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  PreferredSize customAppBar(double width, InboxController ctrl) {
    return PreferredSize(
      preferredSize: Size(width, 280),
      child: SizedBox(
        height: 280.sp,
        child: Stack(
          children: [
            Container(
              width: width,
              padding: EdgeInsets.only(
                  top: 0.sp, bottom: 20.sp, left: 20, right: 20),
              height: 210.h,
              decoration: const BoxDecoration(
                  color: darkBrown,
                  image: DecorationImage(
                      image: AssetImage(
                        ImageAssets.appBarBg1,
                      ),
                      fit: BoxFit.fitHeight)),
              child: SafeArea(
                child: SizedBox(
                  width: 180.sp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: SvgPicture.asset(ImageAssets.appLogoYellow),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          textWidget(
                              text: AppStrings.hi.trArgs([extractFirstName(ctrl.user.value.fullName!)]),
                              style: getRegularStyle(color: white)
                                  .copyWith(fontWeight: FontWeight.w700)),
                          SizedBox(
                            width: 5.sp,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: SvgPicture.asset(ImageAssets.wavingHand),
                          ),
                        ],
                      ),
                      textWidget(
                          text: AppStrings.feelFreetTalkToSupport,
                          textOverflow: TextOverflow.visible,
                          style: getRegularStyle(color: white, fontSize: 12.sp)
                              .copyWith(fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ),
            startConversation(width, ctrl),
          ],
        ),
      ),
    );
  }

  Widget startConversation(double width, InboxController ctrl) {
    return Positioned(
      // top: 180.sp,
      bottom: 10.sp,
      left: 20.sp,
      right: 20.sp,
      child: Column(children: [
        Container(
          width: width.sp,
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2.0.r),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.3),
                  offset: Offset(0.0, 5.0), //(x,y)
                  blurRadius: 4.0,
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  text: AppStrings.hi.trArgs([extractFirstName(ctrl.user.value.fullName!)]),
                  style: getRegularStyle(color: white)
                      .copyWith(fontWeight: FontWeight.w700)),
              SizedBox(
                height: 10.sp,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 144.sp,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(4.r))),
                  padding: EdgeInsets.all(10.sp),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageAssets.chat),
                      SizedBox(
                        width: 4.sp,
                      ),
                      textWidget(
                          text: AppStrings.startConversation,
                          style: getLightStyle(fontSize: 12.sp))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
