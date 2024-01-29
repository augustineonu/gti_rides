  import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gti_rides/shared_widgets/sqaure_check_box_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

Widget carFetures({List<Widget> children = const <Widget>[]}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: textWidget(
                    text: AppStrings.carFeatureCaps,
                    style: getMediumStyle(fontSize: 12.sp, color: grey2)
                        .copyWith(fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          SizedBox(
            height: 10.sp,
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            runSpacing: 5,
            spacing: 0,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget chipWidget({required String title}) {
    return Chip(
      labelPadding: EdgeInsets.all(4),
      side: BorderSide.none,
      color: const MaterialStatePropertyAll(backgroundColor),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      label: textWidget(
          text: title, style: getRegularStyle(fontSize: 10.sp, color: grey2)),
      avatar: sqaureCheckBox(
          padingWidth: 2.sp,
          marginRight: 2.sp,
          border: Border.all(color: primaryColor, width: 1.8),
          color: primaryColor),
    );
  }

  Widget carBasics({
    required String carType,
    required String carSeat,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.carBasicsCaps,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10.sp,
          ),
          Row(
            children: [
              carFeatureBullet(text: carType),
              // const SizedBox(
              //   width: 10,
              // ),
              // carFeatureBullet(text: '4 Doors'),
              const SizedBox(
                width: 10,
              ),
              carFeatureBullet(text: carSeat),
            ],
          ),
        ],
      ),
    );
  }

  Widget carFeatureBullet({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        sqaureCheckBox(
            padingWidth: 2.sp,
            marginRight: 4.sp,
            border: Border.all(color: primaryColor, width: 1.6),
            color: primaryColor),
        textWidget(
            text: text, style: getRegularStyle(fontSize: 10.sp, color: grey2)),
      ],
    );
  }


   Widget transmission({required String transmission}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.transmission,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10.sp,
          ),
          carFeatureBullet(text: transmission),
        ],
      ),
    );
  }

   Widget aboutCar({required String aboutCar}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              textWidget(
                  text: AppStrings.aboutCarCaps,
                  style: getMediumStyle(fontSize: 12.sp, color: grey2)
                      .copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(
            height: 10.sp,
          ),
          textWidget(
              text: aboutCar,
              textOverflow: TextOverflow.visible,
              style: getMediumStyle(fontSize: 10.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }


   Widget tripDate({
    required String startDate,
    required String endDate,
    required Widget trailling
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: AppStrings.availabilityDate,
              style: getMediumStyle(fontSize: 12.sp, color: grey2)
                  .copyWith(fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10.sp,
          ),
          Row(
            children: [
              SvgPicture.asset(ImageAssets.calendar),
              SizedBox(
                width: 10.sp,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                      text: startDate,
                      style: getMediumStyle(fontSize: 12.sp, color: grey3)),
                  SizedBox(
                    height: 5.sp,
                  ),
                  textWidget(
                      text: endDate,
                      style: getMediumStyle(fontSize: 12.sp, color: grey3)),
                ],
              ),
              const Spacer(),
             trailling,
            ],
          ),
        ],
      ),
    );
  }