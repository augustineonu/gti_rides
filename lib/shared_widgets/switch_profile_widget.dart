import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

Widget switchProfileWidget({
  required String title,
  required String imageUrl,
  required Size size,
   void Function()? onTapCarOwner,
   void Function()? onTapCarRenter,
}) {
  return InkWell(
    onTap: () {
      Get.bottomSheet(
        Container(
          padding: EdgeInsets.only(left: 18.sp, top: 22.sp, bottom: 29.sp),
          height: size.height * 0.2,
          child: Column(
            children: [
              InkWell(
                onTap: onTapCarOwner ?? (){},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Image.asset(ImageAssets.owner),
                      SizedBox(
                        width: 5.w,
                      ),
                      textWidget(
                          text: AppStrings.partner,
                          style: getMediumStyle()
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 8.w,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: onTapCarRenter ?? (){},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Image.asset(ImageAssets.renter),
                      SizedBox(
                        width: 5.w,
                      ),
                      textWidget(
                          text: AppStrings.renter,
                          style: getMediumStyle()
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 8.w,
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
            borderRadius: BorderRadius.all(Radius.circular(4.r))),
      );
    },
    child: Container(
      // width: 138.sp,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColorVeryLight,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(imageUrl),
          SizedBox(
            width: 4.w,
          ),
          textWidget(
              text: title,
              style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
          SizedBox(
            width: 8.w,
          ),
          CircleAvatar(
            radius: 15.r,
            backgroundColor: primaryColor,
            child: SvgPicture.asset(
              ImageAssets.arrowDown,
              height: 11.sp,
            ),
          ),
        ],
      ),
    ),
  );
}
