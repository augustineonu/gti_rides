import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
import 'package:gti_rides/utils/utils.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<PaymentController>(PaymentController());
  }
}

class PaymentScreen extends GetView<PaymentController> {
  PaymentScreen([Key? key]) : super(key: key);
  final controller = Get.put<PaymentController>(PaymentController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(() => Scaffold(
          // body: body(size, context)),
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 13.sp),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(6.sp),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tabIndicator(
                                width: 150.sp,
                                title: AppStrings.allApayment,
                                selected: controller.selectedIndex.value == 0,
                                onTap: () {
                                  controller.selectedIndex.value = 0;
                                  controller.paymentMethodView.value = 0;
                                  controller.getPaymentList();
                                  // controller.fullNameController.clear();
                                  // controller.accountNumberController
                                  //     .clear();
                                }),
                            tabIndicator(
                                width: 150.sp,
                                title: controller.addedPaymentMethod.value
                                    ? AppStrings.paymentAccount
                                    : AppStrings.paymentMethod,
                                // if user has added payment account show AppStrings.paymentAccount
                                selected: controller.selectedIndex.value == 1,
                                onTap: () {
                                  controller.selectedIndex.value = 1;
                                  controller.getBankAccount();
                                }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 14.sp,
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          color: primaryColor,
                          onRefresh: () => controller.getPaymentList(),
                          triggerMode: RefreshIndicatorTriggerMode.anywhere,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    buildBody(context, size),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      controller.isLoadingMore.value
                          ? Center(
                              child: SizedBox(
                              height: 40.sp,
                              child: centerLoadingIcon(),
                            ))
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              controller.isFetchingAccountDetails.isTrue ||
                      controller.isGettingPaymentList.isTrue
                  ? Stack(
                      children: [
                        const Opacity(
                          opacity: 0.5,
                          child: ModalBarrier(
                              dismissible: false, color: Colors.black),
                        ),
                        Center(
                          child: Center(child: centerLoadingIcon()),
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
          // }
        ));
  }

  Widget buildBody(
    BuildContext context,
    Size size,
  ) {
    switch (controller.selectedIndex.value) {
      case 0:
        // All payment
        return Obx(() {
          return paymentsCard(size);
        });

      case 1:
        // Payment method
        // if (controller.addedPaymentMethod.value == true) {
        //   return paymentMethod(size, context);
        // }
        // here i am checking for the current payment method, if the user wants to edit
        // i show them the UI.
        // i am also checking if the get bank account returns empty, that means the user
        // haven't added  payment method, then i show then the empty payment method card
        return controller.paymentMethodView.value == 1
            ? addAccountForm(context, size)
            : controller.obx(
                (state) {
                  // controller.fullNameController.clear();
                  // controller.accountNumberController.clear();
                  return paymentMethod(size, context, state,
                      onTapEditPaymentMethod: () async {
                    controller.paymentMethodView.value = 1;
                    controller.goBack();
                  });
                },
                onEmpty: controller.paymentMethodView.value == 0
                    ? noBankAddedCard(size)
                    : addAccountForm(context, size),
                onError: (e) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.height * 0.1, horizontal: 20),
                  child: Center(
                    child: Text(
                      "$e",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onLoading: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height / 3.5),
                      child: Center(child: centerLoadingIcon()),
                    ),
                  ],
                ),
              );

      // if (controller.paymentMethodView.value == 0) {
      //   return noBankAddedCard(size);
      // } else {
      //   return addAccountForm(context, size);
      // }

      default:
        return const SizedBox();
    }
  }

  Widget paymentMethod(Size size, BuildContext context, List<dynamic>? state,
      {void Function()? onTapEditPaymentMethod}) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
          itemCount: state!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0.sp, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                            text: state![0]['bankName'],
                            style: getRegularStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            SizedBox(
                              height: size.height * 0.1.sp,
                              width: size.width.sp,
                              child: InkWell(
                                onTap: onTapEditPaymentMethod,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(ImageAssets.pencilEdit),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      textWidget(
                                          text: 'Edit',
                                          style: getRegularStyle(
                                              color: primaryColor)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            backgroundColor: backgroundColor,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.r),
                                  topRight: Radius.circular(4.r)),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset(ImageAssets.popUpMenu),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  textWidget(
                    text: state[0]['fullName'] ?? '',
                    style: getRegularStyle(fontSize: 12.sp, color: grey3),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  textWidget(
                    text: state[0]['accountNumber'],
                    style: getRegularStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget paymentsCard(Size size) {
    if (controller.paymentList.isNotEmpty) {
      return SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          children: [
            for (var payment in controller.paymentList)
              Column(
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
                              text: payment["paymentStatus"] == 'pending'
                                  ? 'Processing'
                                  : "Sent",
                              style: getMediumStyle(fontSize: 10.sp),
                            ),
                            Image.asset(ImageAssets.doubleCheck),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0.sp, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(
                            text: AppStrings.totalAmount,
                            style:
                                getRegularStyle(fontSize: 12.sp, color: grey3)),
                        Row(
                          // crossAxisAlignment: alignment,
                          children: [
                            SvgPicture.asset(ImageAssets.naira),
                            textWidget(
                                text: payment["paymentAmount"].toString(),
                                style: getMediumStyle(fontSize: 16.sp)
                                    .copyWith(fontFamily: 'Neue')),
                          ],
                        ),
                      ],
                      // Foreatgreen29@#$
                    ),
                  ),
                  tripInfo(
                    title: AppStrings.tripId,
                    trailling: InkWell(
                      onTap: () {
                        controller.copy(value: payment["tripID"]);
                      },
                      child: Row(
                        children: [
                          textWidget(
                            text: payment["tripID"],
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
                  Visibility(
                    visible: payment["paymentDate"] == '' ? false : true,
                    child: tripInfo(
                      title: AppStrings.paymentDate,
                      trailling: textWidget(
                        text: formateDate(date: payment["paymentDate"]),
                        style: getRegularStyle(fontSize: 10.sp),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0.sp, horizontal: 5),
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
                          text:
                              (payment["paymentMethod"] as List?)?.isNotEmpty ==
                                      true
                                  ? payment["paymentMethod"][0]["bankName"]
                                          as String? ??
                                      ""
                                  : "Please kindly setup your payment method",
                          style: getRegularStyle(fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        payment["paymentStatus"] == "pending" ? false : true,
                    child: tripInfo(
                      title: AppStrings.paymentRef,
                      trailling: InkWell(
                        onTap: () {
                          // payment reference
                          controller.copy(value: payment["paymentReference"]);
                        },
                        child: Row(
                          children: [
                            textWidget(
                              text: payment["paymentReference"].toString(),
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
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  divider(color: borderColor),
                  SizedBox(
                    height: 15.sp,
                  ),
                ],
              ),
          ],
        ),
      );
    }
    return noPreviousPaymentWidget(size);
  }

  Form addAccountForm(context, Size size) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: controller.paymentFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dropdownWidget(
            title: AppStrings.selectBank,
            // hintText: 'Select',
            hintText: controller.selectedBank!.value['bankName'] ?? 'Select',
            context: context,
            expectedVariable: 'bank',
            values: controller.listOfBanksAsMap,
            // selectedValue: controller.selectedBank!.value.isNotEmpty
            //     ? controller.selectedBank!.value
            //     : null,
            onChange: (selectedBank) {
              controller.selectedBank!.value = selectedBank;

              print('Selected value: $selectedBank');

              var selectedObject =
                  (controller.listOfBanksAsMap ?? <Map<String, dynamic>>[])
                      .firstWhere(
                (bank) => bank['name'] == selectedBank['name'],
                orElse: () => {},
              );

              if (selectedObject != null) {
                String bankCode = selectedObject['code'] as String;
                String bankName = selectedObject['name'] as String;
                controller.bankCode.value = bankCode;
                controller.bankName.value = bankName;

                if (bankName != controller.selectedBank!.value['name']) {
                  controller.fullNameController.clear();
                  controller.accountNumberController.clear();

                  // Check if accountNumberController is not empty before resolving
                  if (controller.accountNumberController.text.isNotEmpty) {
                    controller.resolveAccount();
                  }
                }
              }
            },
          ),
          const SizedBox(
            height: 22,
          ),
          NormalInputTextWidget(
            onTap: () {
              if (controller.bankCode.value.isEmpty) {
                showErrorSnackbar(message: "Kindly select bank");
                return;
              }
            },
            expectedVariable: 'accountNumber',
            title: AppStrings.bankAccountNumber,
            textInputType: TextInputType.number,
            hintText: AppStrings.bankAccountNumberHintText,
            controller: controller.accountNumberController,
            onEditingComplete: () {
              print("editied value:: ");
              controller.resolveAccount();
            },
            onChanged: (value) {
              if (value.length == 10) {
                // Trigger the API call when the input length is 10
                controller.resolveAccount();
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          const SizedBox(
            height: 22,
          ),
          NormalInputTextWidget(
            expectedVariable: 'fullName',
            title: AppStrings.fullName,
            hintText: AppStrings.bankAccoutName,
            controller: controller.fullNameController,
            readOnly: true,
          ),
          SizedBox(
            height: size.height * 0.1.sp,
          ),
          GtiButton(
            width: 350.sp,
            text: AppStrings.save,
            color: primaryColor,
            onTap: controller.requestOtp,
            isLoading: controller.isLoading.value,
          ),
        ],
      ),
    );
  }

  Widget noBankAddedCard(Size size) {
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
  }

  Widget noPreviousPaymentWidget(Size size) {
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
          text: AppStrings.youHaveNoPaymentRecord,
          textOverflow: TextOverflow.visible,
          style: getRegularStyle(
            color: black,
          ),
        ),
        SizedBox(
          height: size.height * 0.3.sp,
        ),
      ],
    );
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
