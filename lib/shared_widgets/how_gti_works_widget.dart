import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

Widget howGtiWorksCard({void Function()? onTap, required String imageUrl}) {
  return Container(
    // height: 125.sp,
    padding: EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: grey5, width: 0.5),
      borderRadius: BorderRadius.all(
        Radius.circular(4.r),
      ),
      // image: const DecorationImage(
      //     image: AssetImage(ImageAssets.howGtiWorksBg), fit: BoxFit.contain),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            // width: 120.sp,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                      text: AppStrings.howGtiWorksNL,
                      style: getBoldStyle(fontSize: 14.sp)
                          .copyWith(fontFamily: 'neue')),
                  SizedBox(
                    height: 10.sp,
                  ),
                  textWidget(
                      text: AppStrings.weArePeer,
                      style: getLightStyle(fontSize: 10.sp)
                          .copyWith(fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: 10.sp,
                  ),
                  InkWell(
                    onTap: onTap,
                    child: textWidget(
                        text: AppStrings.readMore,
                        style: getLightStyle(fontSize: 10.sp).copyWith(
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(
                4.r,
              ),
            ),
            child: Image.asset(
              "assets/images/smiles_2.png",
              width: 140.sp,
              height: 125.sp,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}
