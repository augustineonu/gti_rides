import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late final Dio _dio;

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
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(
      ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
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
      // internet connection is available, check if Google.com is reachable to return stats 200
      try {
        final response = await _dio.get('https://www.google.com');
        if (response.statusCode != 200 || response.statusCode != 201) {
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
        }
      } catch (exception) {
        throw 'An error occurred';
      }
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
