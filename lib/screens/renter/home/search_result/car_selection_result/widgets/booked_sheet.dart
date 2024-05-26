import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/booked_dates.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/utils.dart';

Future<dynamic> bookedDatedSheet({
  required List<BookedData> itemCount,
}) {
  return Get.bottomSheet(
    SizedBox(
      // height: MediaQuery.of(context).size.height * 0.2.sp,
      // width: MediaQuery.of(context).size.height * 0.2.sp,
      height: 200,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            textWidget(
              text: 'Trip with booked dates',
              style: getBoldStyle(),
            ),
            SizedBox(height: 5.sp,),
            textWidget(
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.visible,
              text:
                  'Kindly review your booking dates as this car has been booked with below dates',
              style: getRegularStyle(),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                itemCount: itemCount.length,
                itemBuilder: (context, index) {
                  var booked = itemCount[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(color: primaryColorLight),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(
                                text: "Start date:", style: getSemiBoldStyle()),
                            textWidget(
                                text: "End date:", style: getSemiBoldStyle()),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(text: formateDate(date: booked.tripStartDate!.toIso8601String()), style: getRegularStyle()),
                            textWidget(text: formateDate(date: booked.tripEndDate!.toIso8601String()), style: getRegularStyle()),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, _) => SizedBox(height: 8),
              ),
            ),
          ],
        ),
      ),
    ),
    backgroundColor: backgroundColor,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.r), topRight: Radius.circular(4.r)),
    ),
  );
}
