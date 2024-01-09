import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/Partner/home/manage_vehicle/quick_edit/quick_edit_controller.dart';
import 'package:gti_rides/shared_widgets/date_container.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/amount_formatter.dart';
import 'package:gti_rides/utils/constants.dart';

class QuickEditBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<QuickEditController>(QuickEditController());
  }
}

class QuickEditScreen extends StatelessWidget {
   QuickEditScreen([Key? key]) : super(key: key);

  final controller = Get.put(QuickEditController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final controller = Get.put<QuickEditController>(QuickEditController());
    return Obx(() => Scaffold(
          appBar: appBar(),
          // body: body(size, context)),
          body: Padding(
            padding: EdgeInsets.only(left: 20.0.sp, right: 20.sp, top: 13.sp),
            child: buildBody(context, size),
          ),
          // }
        ));
  }

  Widget buildBody(context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            carImage(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                imgUrl: controller.photoUrl.value.isEmpty
                    ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnKpMPFWYvaoInINJ44Qh4weo_z8nDwDUf8Q&usqp=CAU'
                    : controller.photoUrl.value,
                height: 33.sp,
                width: 33.sp),
            SizedBox(
              width: 10.sp,
            ),
            textWidget(
                text: controller.brandModelName.value.isNotEmpty
                    ? controller.brandModelName.value
                    : '',
                style: getBoldStyle()),
          ],
        ),
        SizedBox(
          height: 28.sp,
        ),
        textWidget(text: AppStrings.availabilityDate, style: getMediumStyle()),
        SizedBox(
          height: 8.sp,
        ),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: controller.amountFormKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: NormalInputTextWidget(
                      expectedVariable: 'field',
                      title: AppStrings.from,
                      fontSize: 12.sp,
                      hintText: AppStrings.dateTimeHintText,
                      readOnly: true,
                      // showCursor: true,
                      controller: controller.startDateController
                        ..text = controller.startDateTime.value,
                      onTap: () async {
                        var data = await Get.toNamed(AppLinks.chooseTripDate,
                            arguments: {
                              "appBarTitle": AppStrings.quickEdit,
                              "to": AppStrings.to,
                              "from": AppStrings.from
                            });

                        // Handle the selected date here
                        print('Selected Date page: $data');
                        controller.startDateTime.value = data['start'];

                        controller.endDateTime.value = data['end'] ?? '';
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20.sp,
                  ),
                  Expanded(
                    child: NormalInputTextWidget(
                      expectedVariable: 'field',
                      title: AppStrings.to,
                      hintText: AppStrings.dateTimeHintText,
                      readOnly: true,
                      // showCursor: true,
                      fontSize: 12.sp,
                      controller: controller.endDateController
                        ..text = controller.endDateTime.value,
                      onTap: () async {
                        var data = await Get.toNamed(AppLinks.chooseTripDate,
                            arguments: {
                              "appBarTitle": AppStrings.quickEdit,
                              "to": AppStrings.to,
                              "from": AppStrings.from
                            });

                        // Handle the selected date here
                        print('Selected Date page: $data');
                        controller.startDateTime.value = data['start'];

                        controller.endDateTime.value = data['end'] ?? '';
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.sp,
              ),
              NormalInputTextWidget(
                expectedVariable: 'field',
                prefixIcon: Transform.scale(
                  scale: 0.3,
                  child: SvgPicture.asset(
                    ImageAssets.naira,
                  ),
                ),
                title: AppStrings.proposedPricePerDay,
                hintText: AppStrings.amountHintText,
                textInputType: TextInputType.number,
                controller: controller.pricePerDayController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  NumberTextInputFormatter(),
                ],
              ),
            ],
          ),
        ),

        SizedBox(
          height: 50.sp,
        ),
        saveButton(),

      ],
    );
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.quickEdit,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget saveButton() {
    return controller.isLoading.isTrue
        ? centerLoadingIcon()
        : GtiButton(
            text: AppStrings.save,
            color: primaryColor,
            // onTap: () {},
            onTap: controller.quickEditCar,
            isLoading: controller.isLoading.value,
          );
  }
}
