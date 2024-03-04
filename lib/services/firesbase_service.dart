import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/firebase_options.dart';
import 'package:gti_rides/services/logger.dart';
// import 'package:quicklydrop_agent/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseService get firebaseService => Get.find();

class FirebaseService {
  Logger logger = Logger('FirebaseService');
  // ...

  static final FirebaseService _cache = FirebaseService._internal();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  String deviceToken = "";

  factory FirebaseService() {
    return _cache;
  }

  FirebaseService._internal() {
    // Initialize Firebase when the service is created
    init();
  }

  Future<void> init() async {
    logger.log('Initializing firebase service');
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(
    //   // name: 'GTi Rides',
    //     options: DefaultFirebaseOptions.currentPlatform
    //     );
    // getDeviceToken();
  }

  Future<String> getDeviceToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) {
      deviceToken = token!;
      logger.log(" FCM token is $token and $deviceToken");
    });
    return deviceToken;
  }
}
