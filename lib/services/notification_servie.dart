import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/push_notification_model.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:overlay_support/overlay_support.dart';

NotificationService get notificationService => Get.find();
Logger logger = Logger('NotificationService');

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationService {
  static final NotificationService _cache = NotificationService._internal();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  late RxInt totalNotifications;
  final localNotifications = FlutterLocalNotificationsPlugin();
  Rx<PushNotification>? notificationInfo = PushNotification().obs;

  factory NotificationService() {
    return _cache;
  }

  NotificationService._internal() {
    init();
  }

  final androidChannel = const AndroidNotificationChannel(
    "gti_rides_channel1",
    "gti_rides",
    description: "This channel is used for important notification",
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound("gti_rides_sound"),
  );

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message != null) {
      final notification = message.notification;
      if (notification != null) {
        logger.log("Title: " "${notification.title}");
        logger.log("Body: " "${notification.body}");
        logger.log("Payload: " "${notification.body}");

        final pushNotification = PushNotification(
          title: notification.title,
          body: notification.body,
        );
        notificationInfo!.value = pushNotification;
        totalNotifications.value++;

        if (notification.title!.toLowerCase().contains("order")) {
          logger.log("Notification:: ${notification.body ?? "unknown"}");
          // check if user accept order is true/ false
          // route to current order or awaiting order screen
          // routeService.offAllNamed(AppLinks.currentOrders, arguments: {
          //   "title": pushNotification.title,
          //   "body": pushNotification.body,
          // });
        } else {
           logger.log("Notification:: ${notification.body ?? "unknown"}");
          // routeService.offAllNamed(AppLinks.notification, arguments: {
          //   "title": pushNotification.title,
          //   "body": pushNotification.body,
          // });
        }
      }
    }
  }

  Future<void> init() async {
    logger.log("initializing  notification service");
    _firebaseMessaging.isAutoInitEnabled;
    totalNotifications = 0.obs;
    initPushNotifications();
    await initLocalNotifications();
  }

  Future initPushNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // TODO: handle the received notifications

      _firebaseMessaging.getInitialMessage().then(handleMessage);
      _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
        // final pushNotification = PushNotification.fromJson(message.data);

        notificationInfo!.value = notification;
        totalNotifications.value++;

        if (notificationInfo != null) {
          // handleMessage(message);

          localNotifications.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  androidChannel.id,
                  androidChannel.name,
                  channelDescription: androidChannel.description,
                  playSound: androidChannel.playSound,
                  sound: androidChannel.sound,
                  importance: Importance.max,
                  priority: Priority.high,
                  color: primaryColor,
                  icon: "@drawable/ic_launcher",
                  styleInformation: BigTextStyleInformation(notification.body!,
                      htmlFormatBigText: true,
                      contentTitle: notification.title,
                      htmlFormatContent: true),
                ),
                iOS: const DarwinNotificationDetails(
                    sound: "gti_rides_sound.mp3",
                    presentSound: true),
              ),
              payload: jsonEncode(message.toMap()));
        } else {
          logger.log("errror>>>>>>>>");
        }
      });
    } else {
      logger.log('User declined or has not accepted permission');
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    final message = RemoteMessage.fromMap(jsonDecode(payload.toString()));
    await handleMessage(message);
  }

  Future initLocalNotifications() async {
    const androidInitialize =
        AndroidInitializationSettings("@drawable/ic_launcher");
    var iOSInitialize = DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    await localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
      final message =
          RemoteMessage.fromMap(jsonDecode(payload.payload.toString()));
      await handleMessage(message);
    });
    final platform = localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidChannel);
  }
}