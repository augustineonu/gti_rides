import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/notification_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkController extends GetxController {
  Logger logger = Logger("Network Controller::");
  final Connectivity _connectivity = Connectivity();
  late final Dio _dio;
  late StreamSubscription iSubscription;
  bool isDeviceConnected = false;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        // baseUrl: '',
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
        },
        validateStatus: (int? status) {
          return status != null;
          // return status != null && status >= 200 && status < 300;
        },
      ),
    );
    // _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _updateConnectionStatus();
  }

  Future<void> _updateConnectionStatus() async {
    iSubscription = Connectivity().onConnectivityChanged.listen((event) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      // if(mounted){

      // }
      if (!isDeviceConnected) {
        Get.rawSnackbar(
            messageText: const Text('PLEASE CONNECT TO THE INTERNET',
                style: TextStyle(color: Colors.white, fontSize: 14)),
            isDismissible: false,
            duration: const Duration(days: 1),
            backgroundColor: Colors.red[400]!,
            icon: const Icon(
              Icons.wifi_off,
              color: Colors.white,
              size: 35,
            ),
            margin: EdgeInsets.zero,
            snackStyle: SnackStyle.GROUNDED);
      } else {
        logger.log("Connected:: ");
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
      }
    });

    // if (connectivityResult == ConnectivityResult.none) {
    //   Get.rawSnackbar(
    //       messageText: const Text('PLEASE CONNECT TO THE INTERNET',
    //           style: TextStyle(color: Colors.white, fontSize: 14)),
    //       isDismissible: false,
    //       duration: const Duration(days: 1),
    //       backgroundColor: Colors.red[400]!,
    //       icon: const Icon(
    //         Icons.wifi_off,
    //         color: Colors.white,
    //         size: 35,
    //       ),
    //       margin: EdgeInsets.zero,
    //       snackStyle: SnackStyle.GROUNDED);
    // } else {
    //   // internet connection is available, check if Google.com is reachable to return stats 200
    //   try {
    //     final response = await _dio.get('https://www.google.com');
    //     if (response.statusCode != 200 || response.statusCode != 201) {
    //       Get.rawSnackbar(
    //           messageText: const Text('PLEASE CONNECT TO THE INTERNET',
    //               style: TextStyle(color: Colors.white, fontSize: 14)),
    //           isDismissible: false,
    //           duration: const Duration(days: 1),
    //           backgroundColor: Colors.red[400]!,
    //           icon: const Icon(
    //             Icons.wifi_off,
    //             color: Colors.white,
    //             size: 35,
    //           ),
    //           margin: EdgeInsets.zero,
    //           snackStyle: SnackStyle.GROUNDED);
    //     }
    //   } catch (exception) {
    //     throw 'An error occurred';
    //   }
    //   if (Get.isSnackbarOpen) {
    //     Get.closeCurrentSnackbar();
    //   }
    // }
  }
}
