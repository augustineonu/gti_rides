import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/app_bindings.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/route/routes.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'utils/screen_util.dart';
// import 'package:intercom_flutter/intercom_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Intercom.instance.initialize('hivazykc',
      iosApiKey: 'ios_sdk-efac9e9f5fa7bf1e1bfb33d91f1cddd68b47f895',
      androidApiKey: 'android_sdk-3337cce19e6e590feed33d6b48f39eae825fcfd0');

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
    storageService.init().then((_) {
      logger.debug('loading session...');
    });
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
