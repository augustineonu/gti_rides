import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';

import '../styles/styles.dart';

AppBar gtiAppBar(
    {Widget? title,
    Widget? leading,
    bool? hasLeading = true,
    List<Widget>? actions,
    Color? newTextColor,
    Color? newBackgroundColor,
    Color? newIconColor,
    Color? titleColor,
    bool? autoImplyLeading,
    bool? centerTitle,
    PreferredSizeWidget? bottom,
    void Function()? onTap}) {
  return AppBar(
    elevation: 0.0,
    surfaceTintColor: primaryColor,
    backgroundColor: backgroundColor,
    // backgroundColor: newBackgroundColor ?? whiteOrBlackColor(),
    centerTitle: centerTitle ?? true,
    automaticallyImplyLeading: autoImplyLeading ?? false,
    leading: hasLeading! ? GestureDetector(onTap: onTap, child: leading) : null,
    iconTheme: IconThemeData(
      color: newIconColor,
      // color: newIconColor ?? iconColor(),
    ),
    titleTextStyle: getBoldStyle(
      color: black,
      // color: newTextColor ?? textColor(),
      fontSize: 18,
    ),
    title: title,
    // Text(
    //   title!,
    //   style: getSemiBoldStyle(fontSize: 22.sp,
    //   color: titleColor ?? black),
    // ),
    actions: actions,
    bottom: bottom,
  );
}

AppBar gtiAppBarImage(
    {required Function() gotoNotification, required bool hasNewAlerts}) {
  return AppBar(
    elevation: 0.5,
    // backgroundColor: whiteOrBlackColor(),
    centerTitle: false,
    automaticallyImplyLeading: false,
    iconTheme: const IconThemeData(
        // color: iconColor(),
        ),
    titleTextStyle: getBoldStyle(
      // color: textColor(),
      color: black,
      fontSize: 18,
    ),
    // title: Image.asset(
    // ImageAssets.png_long_text_logo,
    // scale: 10,
    // ),
    actions: [
      IconButton(
        icon: const Stack(
          children: <Widget>[
            // Icon(Iconsax.notification),
            // if (listStore.notifications.isNotEmpty)
            //   Positioned(
            //     right: 0,
            //     child: Icon(
            //       Icons.brightness_1,
            //       size: 8.0,
            //       color: Colors.redAccent,
            //     ),
            //   )
          ],
        ),
        // color: iconColor(),
        onPressed: gotoNotification,
      ),
    ],
  );
}

Widget centerLoadingIcon({
  double opacity = 0.5,
  double? value,
}) {
  return Center(
      child: CircularProgressIndicator(
    color: appColors(),
    value: value,
    backgroundColor: secondaryColor.withOpacity(opacity),
  ));
}

Widget divider({double? thickness, Color? color}) {
  return Divider(
    thickness: thickness ?? 1,
    color: color ?? primaryColor,
  );
}

Widget verticalDivider({double? thickness, Color? color}) {
  return VerticalDivider(
    thickness: thickness ?? 1,
    color: color ?? primaryColor,
    indent: 3,
  );
}

enum ImageSourceType {
  network,
  selected,
}

Widget imageAvatar({
  required String imgUrl,
  double? height,
  double? width,
  ImageSourceType sourceType = ImageSourceType.network,
  String? selectedImage,
}) {
  return Stack(
    children: [
      SvgPicture.asset(
        ImageAssets.userOval,
        width: 47.sp,
      ),
      Positioned(
        top: 3,
        left: -2,
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          imageBuilder: (context, imageProvider) => Container(
            width: width ?? 40.0.w,
            height: height ?? 40.0.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => SizedBox(
            height: 38,
            width: 34,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset('assets/images/default_profile_image.png')),
          ),
          errorWidget: (context, url, error) => ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset('assets/images/default_profile_image.png',
                  height: 36.sp, width: 34.sp)),
        ),
      ),
    ],
  );
}

Widget imageAvatar1({
  required String imgUrl,
  double? height,
  double? width,
}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
        border: Border.all(
            width: 3, color: Colors.green, style: BorderStyle.solid)),
    child: CachedNetworkImage(
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width ?? 198.0.w,
        height: height ?? 200.0.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => const SizedBox(
        height: 100,
        width: 104,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        ImageAssets.userIcon,
        height: 34.sp,
        width: 34.sp,
      ),
    ),
  );
}

Widget imageWidget({
  required String imgUrl,
  double? height,
  double? width,
}) {
  return CachedNetworkImage(
    imageUrl: imgUrl,
    imageBuilder: (context, imageProvider) => Container(
      width: width ?? 198.0.w,
      height: height ?? 200.0.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    ),
    placeholder: (context, url) => const SizedBox(
      height: 100,
      width: 104,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    ),
    errorWidget: (context, url, error) => Image.asset(
      ImageAssets.userIcon,
      height: 34.sp,
      width: 34.sp,
    ),
  );
}

Future<dynamic> dialogWidget(
  Size size, {
  required String title,
  double? contentHeight,
  required Widget content,
  AlignmentGeometry? alignment,
  void Function()? onTap,
  double? space,
}) async {
  return await Get.dialog(Dialog(
    alignment: alignment,
    backgroundColor: Colors.transparent,
    child: Container(
      // width: size.width,
      height: contentHeight,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              InkWell(
                onTap: onTap,
                child: SvgPicture.asset(
                  ImageAssets.closeSmall,
                  height: 15.sp,
                  color: black,
                ),
              ),
              const Spacer(),
              textWidget(
                text: title,
                style: getMediumStyle(fontSize: 12.sp)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: space,
          ),
          content,
        ],
      ),
    ),
  ));
}

Future<dynamic> successDialog({
  required String title,
  required String body,
  required String buttonTitle,
  required void Function()? onTap,
}) {
  return Get.dialog(Dialog(
    alignment: Alignment.topCenter,
    insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: Stack(
      children: [
        Positioned(
          top: 0,
          child: SvgPicture.asset(
            ImageAssets.successDialogBg,
            alignment: Alignment.center,
            // width: 200,
            height: 350,
          ),
        ),
        Container(
          height: 400,
          // width: 350.sp,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          // child: ,
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            ImageAssets.success,
            alignment: Alignment.center,
            // width: 200,
            height: 110,
          ),
        ),
        Positioned(
          bottom: 35.sp,
          right: 0,
          left: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textWidget(
                    text: title, style: getBoldStyle(color: primaryColor)),
                SizedBox(
                  height: 10,
                ),
                textWidget(
                    text: body,
                    textOverflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: getRegularStyle()),
                SizedBox(
                  height: 30,
                ),
                GtiButton(
                  text: buttonTitle,
                  onTap: onTap,
                )
              ],
            ),
          ),
        ),
      ],
    ),
  ));
}
