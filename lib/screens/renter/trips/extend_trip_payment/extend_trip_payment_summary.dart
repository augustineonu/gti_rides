import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/payment_summary/payment_summary_controller.dart';
import 'package:gti_rides/screens/renter/trips/extend_trip_payment/extend_trip_payment_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class ExtendTripPaymentSummaryScreen
    extends GetView<ExtendTripPaymentController> {
  ExtendTripPaymentSummaryScreen([Key? key]) : super(key: key);
  @override
  final controller = Get.put(ExtendTripPaymentController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => Stack(
        children: [
          Scaffold(
              backgroundColor: backgroundColor,
              appBar: appBar(),
              body: body(size, context)),
        ],
      ),
      // }
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: () => controller.goBack(),
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.summary,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(size, BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dateTimeColWIdget(
                    alignment: CrossAxisAlignment.start,
                    title: '${controller.formattedStartDayDateMonth.value},',
                    subTitle: controller.formattedStartTime.value),
                SvgPicture.asset(
                  ImageAssets.arrowForwardRounded,
                  height: 24.sp,
                  width: 24.sp,
                  color: primaryColor,
                ),
                dateTimeColWIdget(
                    alignment: CrossAxisAlignment.end,
                    title: '${controller.formattedEndDayDateMonth.value},',
                    subTitle: controller.formattedEndTime.value),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            divider(color: borderColor),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  // crossAxisAlignment: alignment,
                  children: [
                    SvgPicture.asset(ImageAssets.naira),
                    textWidget(
                        text: controller.pricePerDay.value,
                        style: getRegularStyle(color: grey5)),
                    textWidget(text: ' x ', style: getRegularStyle()),
                    textWidget(
                        text: '${controller.tripsDays.toString()}days',
                        style: getRegularStyle(color: grey5)),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(ImageAssets.naira),
                    textWidget(
                        text: controller.tripDaysTotal.value,
                        style: getRegularStyle(color: grey5)),
                  ],
                ),
              ],
            ),
            rowNairaText(
                title: 'Discount',
                hasPreFix: true,
                subTitle: controller.discountTotal.value.toString()),
            rowNairaText(
                title: 'VAT(${controller.vatValue.value}%)',
                subTitle: controller.vat.value),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration:
                  BoxDecoration(color: primaryColorLight.withOpacity(0.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    // crossAxisAlignment: alignment,
                    children: [
                      textWidget(
                          text: 'Total:',
                          style: getRegularStyle()
                              .copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImageAssets.naira,
                      ),
                      textWidget(
                          text: controller.estimatedTotal.value,
                          style: getRegularStyle().copyWith(
                              fontFamily: "Neue", fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60.sp,
            ),
            continueButton(),
          ],
        ));
  }

  Widget rowNairaText({
    required String title,
    required String subTitle,
    bool? hasPreFix = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // crossAxisAlignment: alignment,
            children: [
              textWidget(text: title, style: getRegularStyle(color: grey5)),
            ],
          ),
          Row(
            children: [
              hasPreFix!
                  ? textWidget(text: '- ', style: getRegularStyle(color: grey5))
                  : SizedBox.shrink(),
              SvgPicture.asset(ImageAssets.naira),
              textWidget(text: subTitle, style: getRegularStyle(color: grey5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget dateTimeColWIdget({
    required String title,
    required String subTitle,
    required CrossAxisAlignment alignment,
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        textWidget(
            text: title,
            style: getBoldStyle(
              fontSize: 14.sp,
            )),
        textWidget(text: subTitle, style: getRegularStyle()),
      ],
    );
  }

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 40.sp,
            width: 380.sp,
            text: AppStrings.proceedToPay,
            color: primaryColor,
            // onTap: controller.routeToUpdateKyc,
            onTap: controller.addTrip,
            isLoading: controller.isLoading.value,
          );
  }
}
