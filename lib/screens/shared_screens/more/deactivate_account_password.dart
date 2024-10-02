import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/account_details/account_verification/acount_verification_controller.dart';
import 'package:gti_rides/screens/shared_screens/more/account_details/account_verification/change_password/change_password_controller.dart';
import 'package:gti_rides/screens/shared_screens/more/more_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/normal_text_input_widget.dart';
import 'package:gti_rides/shared_widgets/text_input_widgets/password_input_text_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class DeactivateAccountPassword extends StatelessWidget {
  const DeactivateAccountPassword([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put(MoreController());

    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: gtiAppBar(
          onTap: controller.goBack,
          leading: Icon(
            Icons.arrow_back_rounded,
            color: black,
            size: 24.sp,
          ),
          title: textWidget(
              text: "Delete my Account and Data",
              style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
          titleColor: iconColor(),
        ),
        body: body(context, size, controller: controller),
      ),
      // }
    );
  }

  Widget body(BuildContext context, Size size,
      {required MoreController controller}) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 16.sp),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: controller.deactivateAccountFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textWidget(
                      text:
                          "Dear user, in accordance with our privacy policy, deleting your account and its data can't be undone, so we would need to confirm it's you before proceeding with this request",
                      style: getRegularStyle()
                          .copyWith(fontWeight: FontWeight.w400),
                      textOverflow: TextOverflow.visible),
                  SizedBox(
                    height: 10.sp,
                  ),

                  textWidget(
                      text:
                          "By proceeding with this request, your account will be temporarily disabled, until you reach us via our support",
                      style: getRegularStyle(),
                      textOverflow: TextOverflow.visible),
                  SizedBox(
                    height: 10.sp,
                  ),

                  // NormalInputTextWidget(
                  //     expectedVariable: 'field',
                  //     title: "Kindly provide your details",
                  //     hintText: AppStrings.writeHere,
                  //     maxLines: 5,
                  //     maxLength: 1000,
                  //     inputFormatters: [
                  //       LengthLimitingTextInputFormatter(2000),
                  //     ],
                  //     textInputType: TextInputType.text,
                  //     controller: controller.passwordController,
                  //     titleFontSize: 14.sp),

                  // PasswordInputTextWidget(
                  //   title: "Enter Password",
                  //   controller: controller.passwordController,
                  //   expectedVariable: 'password',
                  //   isObscureValue: controller.showPassword.value,
                  //   onTap: () => controller.obscurePassword(),
                  // ),
                  SizedBox(height: size.height * 0.08),
                  (controller.isLoading.isTrue
                      ? centerLoadingIcon()
                      : GtiButton(
                          height: 45.sp,
                          width: 300.sp,
                          text: AppStrings.cont,
                          color: primaryColor,
                          onTap: controller.deactivateAccount,
                          isLoading: controller.isLoading.value,
                        )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
