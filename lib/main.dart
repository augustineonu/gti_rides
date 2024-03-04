import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/app_bindings.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/route/routes.dart';
import 'package:gti_rides/services/firesbase_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/network_controller.dart';
import 'package:gti_rides/services/notification_servie.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'utils/screen_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:intercom_flutter/intercom_flutter.dart';

void main() async {
  // FirebaseService firebaseService = FirebaseService();
  // await firebaseService.init();
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      // name: 'GTi Rides',
        options: DefaultFirebaseOptions.currentPlatform
        );

  Get.put(UserService());
  await Intercom.instance.initialize('hivazykc',
      iosApiKey: 'ios_sdk-efac9e9f5fa7bf1e1bfb33d91f1cddd68b47f895',
      androidApiKey: 'android_sdk-3337cce19e6e590feed33d6b48f39eae825fcfd0');
  bool isNewUser = await determineUserStatus();

  runApp(GtiRides(
    isNewUser: isNewUser,
  ));
  NetworkController();
}

Future<bool> determineUserStatus() async {
  final user = await userService.getUserData();
  if (user == null) {
    return false;
  } else {
    return true;
  }
}

class GtiRides extends StatefulWidget {
  GtiRides({super.key, required this.isNewUser});
  final bool isNewUser;

  @override
  State<GtiRides> createState() => _GtiRidesState();
}

class _GtiRidesState extends State<GtiRides> {
  Logger logger = Logger('_GtiRidesState');
  AppBinding bindings = AppBinding();
    NetworkController networkController = NetworkController(); // Add this line


  @override
  void initState() {
    logger.log('intState');
    bindings.dependencies();
    // loadImage(ImageAssets.onboarding);
    storageService.init().then((_) {
      logger.debug('loading session...');
      notificationService.init();
    });
    super.initState();

    logger.log("value:::: ${widget.isNewUser}");
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData selectedSize = getScreenSize(context);
    precacheImage(const AssetImage(ImageAssets.onboarding_01), context);
    precacheImage(const AssetImage(ImageAssets.onboarding_02), context);
    precacheImage(const AssetImage(ImageAssets.onboarding03), context);
    logger.log("Second value:::: ${widget.isNewUser}");

    return ScreenUtilInit(
        designSize: selectedSize.size,
        builder: (
          context,
          child,
        ) {
          return GetMaterialApp(
            title: 'GTI Rides',
              // debugShowMaterialGrid : true,
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
            initialRoute: widget.isNewUser
                ? AppLinks.returningUserSplash
                : AppLinks.splash,
            getPages: AppRoutes.pages,
            navigatorObservers: [RouteService(), RouteService().routeObserver],
            onInit: () async {
              networkController.onInit();
            await  firebaseService.getDeviceToken();
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
