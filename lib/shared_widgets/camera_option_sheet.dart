  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

Future<dynamic> selectCameraOptionSheet(Size size,
      {void Function()? onCameraOpen, void Function()? onGelleryOpen}) {
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
                    onTap: onCameraOpen,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GtiButton(
                    width: 120.sp,
                    text: AppStrings.gallery,
                    onTap: onGelleryOpen
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