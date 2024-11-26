import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/account_details/account_details_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class AccountDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<AccountDetailsController>(AccountDetailsController());
  }
}

class AccountDetailsScreen extends GetView<AccountDetailsController> {
  const AccountDetailsScreen([Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        body: body(size, context));
    // }
  }

  AppBar appBar() {
    return gtiAppBar(
      onTap: controller.goBack,
      leading: Transform.scale(
          scale: 0.5,
          child: SvgPicture.asset(ImageAssets.arrowLeft, color: black)),
      centerTitle: true,
      title: textWidget(
          text: AppStrings.accountDetails,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(size, context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: [
                  SvgPicture.asset(ImageAssets.person),
                  const SizedBox(
                    width: 5,
                  ),
                  textWidget(
                      text: AppStrings.loginSettings, style: getBoldStyle()),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            accountDetailsWidget(
              title: AppStrings.email,
              body: controller.user.value.emailAddress!,
              // onTap: controller.routeToEmailInput
            ),
          ],
        ),
        divider(color: borderColor),
        accountDetailsWidget(
            title: AppStrings.password,
            body: '*****************',
            onTap: controller.routeToChangePassword),
        divider(color: borderColor),
        accountDetailsWidget(
            title: AppStrings.mobileNumber,
            body: controller.user.value.phoneNumber!,
            onTap: controller.routeToPhoneInput),
        SizedBox(
          height: size.height * 0.08,
        ),
      ],
    );
  }

  Widget accountDetailsWidget(
      {required String title, required String body, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            textWidget(text: title, style: getRegularStyle(color: black)),
            textWidget(
                text: body ?? '',
                style: getRegularStyle(fontSize: 12.sp, color: grey2)),
          ],
        ),
      ),
    );
  }
}
