import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/renter/home/paint.dart';
import 'package:gti_rides/shared_widgets/gti_btn_widget.dart';
import 'package:gti_rides/shared_widgets/image_loader.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:iconsax/iconsax.dart';

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
    double? toolbarHeight,
    void Function()? onTap}) {
  return AppBar(
    elevation: 0.0,
    surfaceTintColor: primaryColor,
    backgroundColor: backgroundColor,
    toolbarHeight: toolbarHeight,
    // backgroundColor: newBackgroundColor ?? whiteOrBlackColor(),
    centerTitle: centerTitle ?? true,
    automaticallyImplyLeading: autoImplyLeading ?? false,
    leading: hasLeading!
        ? SizedBox(
            width: 20,
            height: 20,
            child: GestureDetector(onTap: onTap, child: leading))
        : null,
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
              child: Image.asset('assets/images/default_profile_image.png',
                  height: 34.sp, width: 34.sp),
            ),
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

Widget profileAvatar({
  String imgUrl =
      "https://img.freepik.com/premium-vector/avatar-profile-icon_188544-4755.jpg",
  double? height,
  double? width,
  double? boxHeight,
  double? boxWidth,
  String? localImagePath,
  BoxFit fit = BoxFit.cover,
  double radius = 100,
}) {
  return SizedBox(
      height: boxHeight ?? 40,
      width: boxWidth ?? 40,
      child: Builder(builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: PercentagePainter(),
              ),
            ),
            localImagePath != null && localImagePath.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Image.file(
                      File(localImagePath),
                      width: width,
                      height: height,
                      fit: fit,
                    ),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        width: width ?? 198.0.w,
                        height: height ?? 200.0.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: ResizeImage(imageProvider,
                                  width: 50, height: 50),
                              fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => const SizedBox(
                        height: 30,
                        width: 30,
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
                    )),
          ],
        );
      }));
}

Widget carImage(
    {required String imgUrl,
    // String? localImagePath,
    double? width,
    double? height,
    double imageSizeWidth = 34.0,
    double imageSizeHeight = 34.0,
    BoxFit fit = BoxFit.cover,
    BorderRadiusGeometry? borderRadius}) {
  // if (imgUrl != null || imgUrl.isNotEmpty) {
  // if (localImagePath != null && localImagePath.isNotEmpty) {
  //   print("Image widget: is running in background");
  //   return Builder(builder: (context) {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(radius),
  //       child: Image.file(
  //         File(localImagePath),
  //         width: width,
  //         height: height,
  //         fit: fit,
  //       ),
  //     );
  //   });
  // } else {
  return CachedNetworkImage(
    alignment: Alignment.center,
    imageUrl: imgUrl,
    fit: BoxFit.contain,
    imageBuilder: (context, imageProvider) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: SafeCachedNetworkImageProvider(
            imgUrl,
            fallbackImage: const AssetImage('assets/images/fav_car.png'),
          ),
          fit: fit,
        ),
      ),
    ),
    placeholder: (context, url) => SizedBox(
      height: imageSizeHeight,
      width: imageSizeWidth,
      child: const Center(
        child: CircularProgressIndicator(
          color: primaryColorLight,
          value: 30,
        ),
      ),
    ),
    errorWidget: (context, url, error) => Image.asset(
      'assets/images/fav_car.png',
      height: imageSizeHeight,
      width: imageSizeWidth,
    ),
  );
  // } else {
  //   return SizedBox();
  // }
}

// }

Widget imageWidget({
  required String imgUrl,
  String? localImagePath,
  double? width,
  double? height,
  double imageSizeWidth = 34.0,
  double imageSizeHeight = 34.0,
  BoxFit fit = BoxFit.cover,
  double radius = 100,
}) {
  if (localImagePath != null && localImagePath.isNotEmpty) {
    print("Image widget: is running in background");
    return Builder(builder: (context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.file(
          File(localImagePath),
          width: width,
          height: height,
          fit: fit,
        ),
      );
    });
  } else {
    print("Image widget: :2   is running in background");
    return CachedNetworkImage(
      alignment: Alignment.center,
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => SizedBox(
        height: imageSizeHeight,
        width: imageSizeWidth,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
            value: 50,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        ImageAssets.userIcon,
        height: imageSizeHeight,
        width: imageSizeWidth,
      ),
    );
  }
}

Widget imageWidget1({
  String? localImagePath,
  String? networkImagePath,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  void Function()? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Builder(builder: (context) {
            if (networkImagePath != null && networkImagePath.isNotEmpty) {
              // Display network image if available
              return Image.network(
                networkImagePath,
                width: width,
                height: height,
                fit: fit,
              );
            } else if (localImagePath != null && localImagePath.isNotEmpty) {
              // Display local image if available
              return Image.file(
                File(localImagePath),
                width: width,
                height: height,
                fit: fit,
              );
            } else {
              // Placeholder or default image when neither local nor network image is available
              return Container(
                width: width,
                height: height,
                color: Colors.grey, // Placeholder color or add a default image
              );
            }
          }),
        ),
        if (onTap != null &&
            (localImagePath != null || networkImagePath != null))
          Positioned(
            right: -4,
            top: -6,
            child: Transform.scale(
              scale: 0.4,
              child: SvgPicture.asset(
                ImageAssets.closeSmall,
                color: red,
              ),
            ),
          ),
      ],
    ),
  );
}

Widget profileImageWidget({
  required String imgUrl,
  String? localImagePath, // Add this parameter for the local image path
  double? height,
  double? width,
}) {
  return Image(
    image: localImagePath != null
        ? AssetImage(localImagePath)
            as ImageProvider<Object> // Use localImagePath if available
        : NetworkImage(imgUrl), // Fallback to network image URL
    width: width ?? 34.0.w,
    height: height ?? 34.0.h,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      // If there's an error loading the image, display a placeholder
      return Image.asset(
        ImageAssets.userIcon,
        height: 34.sp,
        width: 34.sp,
      );
    },
  );
}

Future<dynamic> dialogWidgetWithClose(
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
            height: 20.sp,
          ),
          Expanded(child: SingleChildScrollView(child: content)),
        ],
      ),
    ),
  ));
}

Future<dynamic> infoDialog({
  required String content,
  double? contentHeight,
  void Function()? onTap,
  double? space,
}) async {
  return await Get.dialog(Dialog(
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
              const Spacer(),
            ],
          ),
          textWidget(
            text: content,
            style: getRegularStyle(),
          ),
          SizedBox(
            height: space,
          ),
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
  return Get.dialog(
    Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
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
                  const SizedBox(
                    height: 10,
                  ),
                  textWidget(
                      text: body,
                      textOverflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: getRegularStyle()),
                  const SizedBox(
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
    ),
    barrierDismissible: false,
  );
}

Future<bool?> guestActionDialog({required String action}) async {
// Future<bool?> showLocationPermissionDialog(BuildContext context) async {
  return showDialog<bool>(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: textWidget(
            text: 'Ooops! Kindly Signup',
            textOverflow: TextOverflow.visible,
            style: getRegularStyle()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.warning_25,
                  color: primaryColor,
                  size: 38,
                ),
                SizedBox(
                  width: 30.sp,
                ),
              ],
            ),
            const SizedBox(height: 20),
            textWidget(
                text:
                    "You will have to be signedin to GTi Rides to be able to $action",
                textOverflow: TextOverflow.visible,
                style: getRegularStyle()),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Allow
            },
            child: textWidget(text: 'Continue', style: getRegularStyle()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Decline
            },
            child: textWidget(text: 'Decline', style: getRegularStyle()),
          ),
        ],
      );
    },
  );
}
