import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/renter/favorite_cars_model.dart';
import 'package:gti_rides/screens/shared_screens/more/favorite/favorite_controller.dart';
import 'package:gti_rides/shared_widgets/generic_car_widgets.dart';
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
        body: RefreshIndicator(
          onRefresh: () => controller.getFavoriteCars(),
          child: Stack(
            children: [
              body(size, context),
              controller.isDeletingFavCar.value
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
        ));
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

  Widget body(Size size, BuildContext context) {
    return controller.obx(
      (carData) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 10.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (FavoriteCarData favCar in carData ?? [])
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: greyLight),
                      borderRadius: BorderRadius.all(Radius.circular(4.r))),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      carImage(
                        width: 110,
                        height: 105,
                        imgUrl: favCar.photoUrl,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            bottomLeft: Radius.circular(4.r)),
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
                                      text:
                                          "${favCar.brandName} ${favCar.brandModelName}",
                                      style: getBoldStyle()),
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
                                            text:
                                                '${favCar.percentageRate.toString()}%',
                                            style: getMediumStyle(
                                              fontSize: 12.sp,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    ' (${favCar.tripsCount.toString()} trips)',
                                                style: getLightStyle(
                                                    fontSize: 12.sp,
                                                    color: grey2),
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
                                        text:
                                            '${favCar.pricePerDay.toString()}/day',
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
                            InkWell(
                              onTap: () {
                                deleteVehicleSheet(
                                  size,
                                  title: AppStrings.areYouSuretToRemovefavorite
                                      .trArgs([
                                    favCar.brandName,
                                    favCar.brandModelName
                                  ]),
                                  subTitle: AppStrings
                                      .carWouldNotBeAvailableInTheListOfFav
                                      .trArgs([
                                    favCar.brandName,
                                    favCar.brandModelName
                                  ]),
                                  onTapCancel: controller.goBack,
                                  onTapContinue: () => controller
                                      .deleteFavoriteCar(carId: favCar.carId),
                                );
                              },
                              child: Row(
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
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          )),
      onEmpty: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(
            child: textWidget(
                text: AppStrings.noAddedCarsToFav, style: getMediumStyle())),
      ),
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
      onLoading: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
        child: Center(child: centerLoadingIcon()),
      ),
    );
  }
}
