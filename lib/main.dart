import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/app_bindings.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/route/routes.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'utils/screen_util.dart';

void main() {
  runApp(const GtiRides());
}

class GtiRides extends StatefulWidget {
  const GtiRides({super.key});

  @override
  State<GtiRides> createState() => _GtiRidesState();
}

class _GtiRidesState extends State<GtiRides> {
  Logger logger = Logger('_GtiRidesState');
  AppBinding bindings = AppBinding();

  @override
  void initState() {
    logger.log('intState');
    bindings.dependencies();
    // loadImage(ImageAssets.onboarding);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData selectedSize = getScreenSize(context);
    precacheImage(const AssetImage(ImageAssets.onboarding_01), context);
    precacheImage(const AssetImage(ImageAssets.onboarding_02), context);
    precacheImage(const AssetImage(ImageAssets.onboarding03), context);

    return ScreenUtilInit(
        designSize: selectedSize.size,
        builder: (
          context,
          child,
        ) {
          return GetMaterialApp(
            title: 'GTI Rides',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: white),
              scaffoldBackgroundColor: backgroundColor,
              // backgroundColor: backgroundColor,
              useMaterial3: true,
              appBarTheme: const AppBarTheme(),

              textTheme: const TextTheme(
                bodyMedium: TextStyle(
                  fontFamily: 'Basis Grotesque Pro',
                  fontFamilyFallback: ['Reckless Neue', 'sans-serif'],
                ),
              ),
            ),
            initialRoute: AppLinks.splash,
            getPages: AppRoutes.pages,
            navigatorObservers: [RouteService(), RouteService().routeObserver],
            onInit: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown
              ]);
            },
            debugShowCheckedModeBanner: false,
            // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          );
        });
  }
}
