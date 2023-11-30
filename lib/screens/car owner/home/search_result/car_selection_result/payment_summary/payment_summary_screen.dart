import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/car_selection_result/payment_summary/payment_summary_controller.dart';
import 'package:gti_rides/screens/car%20renter/home/search_result/car_selection_result/update_kyc/update_kyc_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class PaymentSummaryBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<PaymentSummaryController>(PaymentSummaryController());
  }
}

class PaymentSummaryScreen extends GetView<PaymentSummaryController> {
  const PaymentSummaryScreen([Key? key]) : super(key: key);

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
      leading: const Icon(Icons.arrow_back),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.summary,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(Size size, context) {
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
                    title: 'Wed, 1 Nov,',
                    subTitle: '9:00am'),
                SvgPicture.asset(
                  ImageAssets.arrowForwardRounded,
                  height: 24.sp,
                  width: 24.sp,
                  color: primaryColor,
                ),
                dateTimeColWIdget(
                    alignment: CrossAxisAlignment.end,
                    title: 'Wed, 1 Nov,',
                    subTitle: '9:00am'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            divider(color: borderColor),
            SizedBox(
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
                        text: '100,000', style: getRegularStyle(color: grey5)),
                    textWidget(text: ' x ', style: getRegularStyle()),
                    textWidget(
                        text: '5days', style: getRegularStyle(color: grey5)),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(ImageAssets.naira),
                    textWidget(
                        text: '500,000', style: getRegularStyle(color: grey5)),
                  ],
                ),
              ],
            ),
            rowNairaText(title: 'VAT(7.5%)', subTitle: '1,000'),
            rowNairaText(title: 'Pick up', subTitle: '10,000'),
            rowNairaText(title: 'Escort Service Fee', subTitle: '20,000'),
            rowNairaText(title: 'Drop off', subTitle: '10,000'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  // crossAxisAlignment: alignment,
                  children: [
                    textWidget(
                        text: 'Caution Fee (Self drive)',
                        style: getRegularStyle(color: grey5)),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(ImageAssets.naira),
                    textWidget(
                        text: '500,000', style: getRegularStyle(color: grey5)),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 180.sp,
              child: textWidget(
                  text: AppStrings.feeWillBeRefundedWhen,
                  textOverflow: TextOverflow.visible,
                  style: getLightStyle(fontSize: 10.sp, color: primaryColor)),
            ),
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
                          text: '500,000',
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

  Widget identityVerificationWidget({
    required String title,
    required String subTitle,
    void Function()? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textWidget(text: title, style: getRegularStyle(color: black)),
                textWidget(
                    text: subTitle,
                    style: getRegularStyle(fontSize: 12.sp, color: grey2)),
              ],
            ),
          ),
        ),
        divider(color: borderColor),
      ],
    );
  }

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 40.sp,
            width: 380.sp,
            text: 
            // controller.args
            //     ? AppStrings.proceedToPay
            //     : 
                AppStrings.sendRequest,
            color: primaryColor,
            // onTap: controller.routeToUpdateKyc,
            onTap: () {
              successDialog(title: AppStrings.extendedTripSuccessMessage,
              body: AppStrings.extendedTripSuccessMessage1,
              buttonTitle: AppStrings.home,
              onTap: controller.routeToHome );
            },
            isLoading: controller.isLoading.value,
          );
  }



  // Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
  //           child: Row(
  //             children: [
  //               textWidget(
  //                   text: AppStrings.addDisplayPic, style: getBoldStyle()),
  //             ],
  //           ),
  //         ),

  //         /// Identity verification
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20),
  //           child: Row(
  //             children: [
  //               SvgPicture.asset(ImageAssets.identityV),
  //               const SizedBox(width: 6),
  //               textWidget(
  //                   text: AppStrings.identityVerificationCaps,
  //                   style: getBoldStyle()),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         identityVerificationWidget(
  //             title: AppStrings.proofOfIdentity,
  //             subTitle: AppStrings.addDocument,
  //             onTap: () {}),
  //         identityVerificationWidget(
  //             title: AppStrings.gender,
  //             subTitle: AppStrings.selectGender,
  //             onTap: () {}),
  //         identityVerificationWidget(
  //             title: AppStrings.dob,
  //             subTitle: AppStrings.provideDob,
  //             onTap: () {}),
  //         identityVerificationWidget(
  //             title: AppStrings.emergencyContactDetails,
  //             subTitle: AppStrings.inputEmergencyDetails,
  //             onTap: () {}),
  //         identityVerificationWidget(
  //             title: AppStrings.driversLicense,
  //             subTitle: AppStrings.provideDriversLicense,
  //             onTap: () {}),

  //         // address verification
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //           child: Row(
  //             children: [
  //               SvgPicture.asset(
  //                 ImageAssets.location1,
  //                 height: 18.sp,
  //               ),
  //               const SizedBox(width: 6),
  //               textWidget(
  //                   text: AppStrings.addressVerificationCaps,
  //                   style: getBoldStyle()),
  //             ],
  //           ),
  //         ),
  //         identityVerificationWidget(
  //             title: AppStrings.homeAddress,
  //             subTitle: AppStrings.provideHomeAddress,
  //             onTap: () {}),
  //         identityVerificationWidget(
  //             title: AppStrings.officeAddress,
  //             subTitle: AppStrings.addOfficeAddress,
  //             onTap: () {}),
  //         identityVerificationWidget(
  //             title: AppStrings.occupation,
  //             subTitle: AppStrings.provideOccupation,
  //             onTap: () {}),
  //         SizedBox(
  //           height: size.height * 0.07,
  //         ),
  //         continueButton(),
  //         textWidget(text: controller.testString(), style: getMediumStyle()),
  //       ],
  //     ),
}
