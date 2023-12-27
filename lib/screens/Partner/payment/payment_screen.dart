import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/Partner/payment/payment_controller.dart';
import 'package:gti_rides/shared_widgets/dropdown_widget.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/tab_indicator.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<PaymentController>(PaymentController());
  }
}

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put<PaymentController>(PaymentController());
    return Obx(() => Scaffold(
          // body: body(size, context)),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 13.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(6.sp),
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(4.r))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tabIndicator(
                            width: 150.sp,
                            title: AppStrings.allApayment,
                            selected: controller.selectedIndex.value == 0,
                            onTap: () => controller.selectedIndex.value = 0),
                        tabIndicator(
                            width: 150.sp,
                            title: controller.addedPaymentMethod.value
                                ? AppStrings.paymentAccount
                                : AppStrings.paymentMethod,
                            // if user has added payment account show AppStrings.paymentAccount
                            selected: controller.selectedIndex.value == 1,
                            onTap: () => controller.selectedIndex.value = 1),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.sp,
                  ),
                  buildBody(context, size),
                  textWidget(
                      text: controller.testString.value,
                      style: getRegularStyle()),
                ],
              ),
            ),
          ),
          // }
        ));
  }

  Widget buildBody(context, Size size) {
    switch (controller.selectedIndex.value) {
      case 0:
        // All payment
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                bottom: 1,
              ),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r),
                  )),
              child: Container(
                height: 30.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(2.5.r),
                      bottomRight: Radius.circular(2.5.r),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget(
                      text: AppStrings.paymentStatus,
                      // show AppStrings.aAvailabilityDate
                      style: getMediumStyle(
                        color: grey3,
                        fontSize: 10.sp,
                      ),
                    ),
                    Row(children: [
                      textWidget(
                        text: AppStrings.sent,
                        style: getMediumStyle(fontSize: 10.sp),
                      ),
                      Image.asset(ImageAssets.doubleCheck),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0.sp, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textWidget(
                      text: AppStrings.totalAmount,
                      style: getRegularStyle(fontSize: 12.sp, color: grey3)),
                  Row(
                    // crossAxisAlignment: alignment,
                    children: [
                      SvgPicture.asset(ImageAssets.naira),
                      textWidget(
                          text: '500,000',
                          style: getMediumStyle(fontSize: 16.sp)
                              .copyWith(fontFamily: 'Neue')),
                    ],
                  ),
                ],
              ),
            ),
            tripInfo(
              title: AppStrings.tripId,
              trailling: InkWell(
                onTap: () {
                  controller.copy(value: "GTI123456");
                },
                child: Row(
                  children: [
                    textWidget(
                      text: 'GTI123456',
                      style: getRegularStyle(
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(
                      width: 3.sp,
                    ),
                    SvgPicture.asset(ImageAssets.docCopy),
                  ],
                ),
              ),
            ),
            tripInfo(
              title: AppStrings.tripStartDate,
              trailling: textWidget(
                text: 'Wed, 1 Nov, 9:00am',
                style: getRegularStyle(fontSize: 10.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0.sp, horizontal: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 2.sp,
                    height: 16.sp,
                    child: const ColoredBox(
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 7.sp,
                  ),
                  textWidget(
                    text: 'UBA',
                    style: getRegularStyle(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
            tripInfo(
              title: AppStrings.paymentRef,
              trailling: InkWell(
                onTap: () {
                  controller.copy(value: "GTI123456");
                },
                child: Row(
                  children: [
                    textWidget(
                      text: 'GTI123456',
                      style: getRegularStyle(
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(
                      width: 3.sp,
                    ),
                    SvgPicture.asset(ImageAssets.docCopy),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5.sp,
            ),
            divider(color: borderColor)
          ],
        );

      case 1:
        // Completed trips
        if (controller.addedPaymentMethod.value == true) {
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0.sp, horizontal: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 2.sp,
                  height: 16.sp,
                  child: const ColoredBox(
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  width: 7.sp,
                ),
                textWidget(
                  text: 'UBA',
                  style: getRegularStyle(fontSize: 10.sp),
                ),
              ],
            ),
          );
          tripInfo(
            title: AppStrings.paymentRef,
            trailling: InkWell(
              onTap: () {
                controller.copy(value: "GTI123456");
              },
              child: Row(
                children: [
                  textWidget(
                    text: 'GTI123456',
                    style: getRegularStyle(
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(
                    width: 3.sp,
                  ),
                  SvgPicture.asset(ImageAssets.docCopy),
                ],
              ),
            ),
          );
        }

        if (controller.paymentMethodView.value == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.1.sp,
              ),
              SvgPicture.asset(ImageAssets.folder),
              SizedBox(
                height: 26.sp,
              ),
              textWidget(
                text: AppStrings.youHaveNoAccountAdded,
                textOverflow: TextOverflow.visible,
                style: getRegularStyle(
                  color: black,
                ),
              ),
              SizedBox(
                height: size.height * 0.3.sp,
              ),
              GtiButton(
                text: AppStrings.addInfo,
                width: 350,
                onTap: () => controller.paymentMethodView.value = 1,
              ),
            ],
          );
        } else {
          return Column(
            children: [
              NormalInputTextWidget(
                expectedVariable: '',
                title: AppStrings.fullName,
                hintText: AppStrings.nameHintText,
              ),
              const SizedBox(
                height: 22,
              ),
              dropdownWidget(
                title: AppStrings.selectBank,
                hintText: 'Select',
                context: context,
                values: controller.listOfBanksAsMap,
                onChange: (value) {
                  print('Selected value: $value');
                },
              ),
              const SizedBox(
                height: 22,
              ),
              NormalInputTextWidget(
                expectedVariable: '',
                title: AppStrings.bankAccountNumber,
                hintText: AppStrings.bankAccountNumberHintText,
              ),
              SizedBox(
                height: size.height * 0.1.sp,
              ),
              GtiButton(
                width: 350.sp,
                text: AppStrings.save,
                color: primaryColor,
                onTap: controller.routeToVerifyOtp,
                isLoading: controller.isLoading.value,
              ),
            ],
          );
        }

      default:
        return const SizedBox();
    }
  }

  Widget tripInfo(
      {required String title,
      required Widget trailling,
      FontWeight? fontWeight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget(
            text: title,
            textOverflow: TextOverflow.visible,
            style: getRegularStyle(color: grey3, fontSize: 12.sp)
                .copyWith(fontWeight: fontWeight),
          ),
          trailling
        ],
      ),
    );
  }

  Widget continueButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            height: 40.sp,
            width: 3000.sp,
            text: "continue".tr,
            color: primaryColor,
            // onTap: controller.routeToPhoneVerification,
            isLoading: controller.isLoading.value,
          );
  }
}
