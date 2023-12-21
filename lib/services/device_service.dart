import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'logger.dart';

DeviceService get deviceService => Get.find();

class DeviceService with WidgetsBindingObserver {
  Logger logger = Logger('DeviceService');

  static final DeviceService _cache = DeviceService._internal();
  bool keyboardVisible = false;
  String deviceType = 'Test device';
  String deviceId = '';
  String deviceModel = '23';
  bool inTestMode = Platform.environment['FLUTTER_TEST'] == 'true';
  

  factory DeviceService() {
    return _cache;
  }

  DeviceService._internal() {
    init();
  }

  void init() {
    logger.log('intialiazing device service...');
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    getDeviceInfo();


  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.log('AppLifecycleState: $state');
    super.didChangeAppLifecycleState(state);
  }

  void dispose() {
    logger.log('app disposed');
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    logger.log('metrics changed');
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    keyboardVisible = bottomInset > 0.0;
    if (keyboardVisible) logger.log('keyboard is open');
  }

  Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    logger.log("Getting device info");
    logger.log("deviceType 1: $deviceType");

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      logger.log(androidInfo.data.toString());
      deviceType = 'Android';
    } else if (Platform.isIOS) {
      IosDeviceInfo iOSinfo = await deviceInfo.iosInfo;
      deviceId = iOSinfo.identifierForVendor!;
      logger.log(iOSinfo.data.toString());
      deviceType = 'iOS';
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      deviceId = linuxInfo.machineId!;
      deviceType = 'Linux';
      logger.log(linuxInfo.data.toString());
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      deviceType = 'MacOS';
      logger.log(macOsInfo.data.toString());
    } else if (Platform.isWindows) {
      WindowsDeviceInfo info = await deviceInfo.windowsInfo;
      logger.log(info.data.toString());
      deviceType = 'Windows';
    }
    return deviceType;
  }

  Future<Position> getDeviceCoordinates() async {
    logger.log('... getting device geo coordinates');
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLocationEnabled() async {
    logger.log('... checking is app has location permission');
    bool phoneLocationService = await Geolocator.isLocationServiceEnabled();
    logger.log('...??..L $phoneLocationService');
    if (!phoneLocationService) {
      // Todo: Show dialog

      // await showCustomDialog(
      //   message: 'please_enable_your_location'.tr,
      //   singleBtnText: 'enable'.tr,
      //   singleBtnPressed: () async {
      //     await launchAppSettings();
      //     routeService.goBack();
      //   },
      // );
    }
    return phoneLocationService;
    // final status = await Permission.location.status;
    // logger.log('LSTATUS $status');
    // logger.log('LSTATUSPER ${PermissionStatus.granted}');
    // return status == PermissionStatus.granted;
  }

  Future<bool> isLocationPermissionGranted() async {
    logger.log('... checking if app has location permission');
    final status = await Permission.location.status;
    logger.log('LSTATUS $status');
    logger.log('LSTATUSPER ${PermissionStatus.granted}');
    return status == PermissionStatus.granted;
  }

  Future<void> requestLocationPermission() async {
    logger.log('requesting location permission');
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    } else {
      logger.log('prermission granted!');
    }
  }

  Future<void> launchAppSettings() async {
    logger.log('launching app setting');

    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      logger.log('Error launching settings: $e');

      // Todo: Show dialog

      // await showCustomDialog(
      //   message: 'error_launching_settings'.tr,
      //   singleBtnText: 'ok'.tr,
      //   singleBtnPressed: () async {
      //     routeService.goBack();
      //   },
      // );
    }

    return;
  }

  bool getDeviceDarkMode() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  Future<String?> getUserState() async {
    logger.log('... getting user current state - location');
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return placemarks[0].administrativeArea; // returns state
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserCountry() async {
    logger.log('... getting user current country - location');
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return placemarks[0].country; // returns country
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserAddress() async {
    logger.log('... getting user current full address - location');
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      final address =
          '${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}';
      return address; // returns full address
    } catch (e) {
      return null;
    }
  }
}