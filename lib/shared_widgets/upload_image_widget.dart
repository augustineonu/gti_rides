  import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';

Widget imageUploadWidget({
    required void Function()? onTap,
    required String title,
    required String body,
  }) {
    return DottedBorder(
      color: primaryColor,
      strokeWidth: 1,
      padding:
          EdgeInsets.only(left: 13, right: 25.sp, top: 12.sp, bottom: 12.sp),
      child: GestureDetector(
          onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200.sp,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                      text: title,
                      textOverflow: TextOverflow.visible,
                       style: getRegularStyle(color: primaryColor)),
                  SizedBox(
                    height: 4,
                  ),
                  textWidget(
                      text: body,
                      style: getRegularStyle(fontSize: 10.sp, color: grey2)),
                ],
              ),
            ),
            SvgPicture.asset(ImageAssets.imageCard)
          ],
        ),
      ),
    );
  }
