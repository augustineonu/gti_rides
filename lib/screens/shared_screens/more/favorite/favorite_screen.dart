import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/shared_screens/more/favorite/favorite_controller.dart';
import 'package:gti_rides/shared_widgets/generic_widgts.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<FavoriteController>(FavoriteController());
  }
}

class FavoriteScreen extends GetView<FavoriteController> {
  const FavoriteScreen([Key? key]) : super(key: key);
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
          text: AppStrings.favorite,
          style: getMediumStyle().copyWith(fontWeight: FontWeight.w500)),
      titleColor: iconColor(),
    );
  }

  Widget body(size, context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: greyLight),
                  borderRadius: BorderRadius.all(Radius.circular(4.r))),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.r),
                        bottomLeft: Radius.circular(4.r)),
                    child: Image.asset(
                      'assets/images/fav_car.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 135.sp,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(
                                  text: 'Tesla Model Y', style: getBoldStyle()),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      ImageAssets.thumbsUpPrimaryColor),
                                  SizedBox(
                                    width: 5.sp,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: '97%',
                                        style: getMediumStyle(
                                          fontSize: 12.sp,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: ' (66 trips)',
                                            style: getLightStyle(
                                                fontSize: 12.sp, color: grey2),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(ImageAssets.tag),
                                  SizedBox(
                                    width: 2.sp,
                                  ),
                                  SvgPicture.asset(ImageAssets.naira),
                                  SizedBox(
                                    width: 2.sp,
                                  ),
                                  textWidget(
                                    text: '5,000/day',
                                    style: getMediumStyle(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(ImageAssets.location1),
                                  SizedBox(
                                    width: 5.sp,
                                  ),
                                  textWidget(
                                    text: 'Surulere, Lagos state',
                                    textOverflow: TextOverflow.visible,
                                    style: getMediumStyle(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(ImageAssets.treashBin),
                            SizedBox(
                              width: 3.sp,
                            ),
                            textWidget(
                              text: AppStrings.remove,
                              style: getMediumStyle(
                                  fontSize: 10.sp, color: primaryColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
