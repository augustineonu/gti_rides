import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/car%20renter/more/account_details/account_details_controller.dart';
import 'package:gti_rides/screens/car%20renter/more/account_details/account_verification/acount_verification_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class PhoneInputScreen extends StatelessWidget {
  const PhoneInputScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put(AccountVerificationController());
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(controller),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NormalInputTextWidget(
                expectedVariable: 'phone',
                title: AppStrings.inputPhoneNumber,
                hintText: AppStrings.phoneHintText,
                textInputType: TextInputType.phone,
                controller: controller.phoneController,
              ),
              SizedBox(
                height: 30.sp,
              ),
              controller.isLoading.isTrue
                  ? centerLoadingIcon()
                  : GtiButton(
                      height: 40.sp,
                      width: size.width.sp,
                      text: AppStrings.cont,
                      onTap: controller.routeToVerifyPhoneNumber,
                      isLoading: controller.isLoading.value,
                    ),
            ],
          ),
        ));
    // }
  }

  AppBar appBar(AccountVerificationController controller) {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: const Icon(Icons.arrow_back),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.phoneNumber,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }
}
