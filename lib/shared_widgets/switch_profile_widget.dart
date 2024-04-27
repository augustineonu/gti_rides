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
  return GestureDetector(
    onTap: () {
      Get.bottomSheet(
        Container(
          padding: EdgeInsets.only(top: 22.sp, bottom: 29.sp),
          height: size.height * 0.2,
          child: Column(
            children: [
              InkWell(
                onTap: onTapCarOwner ?? () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 18),
                  child: Row(
                    children: [
                      Image.asset(ImageAssets.partner1),
                      SizedBox(
                        width: 10.w,
                      ),
                      textWidget(
                          text: AppStrings.partner,
                          style: getMediumStyle(fontSize: 16)
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 8.w,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: onTapCarRenter ?? () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 18),
                  child: Row(
                    children: [
                      Image.asset(ImageAssets.renter1),
                      SizedBox(
                        width: 10.w,
                      ),
                      textWidget(
                          text: AppStrings.renter,
                          style: getMediumStyle(fontSize: 16)
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
    child: Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(imageUrl),
            SizedBox(
              width: 8,
            ),
            textWidget(
                text: title,
                style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 15.r,
            backgroundColor: primaryColor,
            child: SvgPicture.asset(
              ImageAssets.arrowDown,
              height: 11.sp,
            ),
          ),
        ),
      ],
    ),
  );
}
