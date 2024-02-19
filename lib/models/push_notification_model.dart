// To parse this JSON data, do
//
//     final pushNotification = pushNotificationFromJson(jsonString);

import 'dart:convert';

PushNotification pushNotificationFromJson(String str) => PushNotification.fromJson(json.decode(str));

String pushNotificationToJson(PushNotification data) => json.encode(data.toJson());

class PushNotification {
    final String? title;
    final String? body;

    PushNotification({
        this.title,
        this.body,
    });

    factory PushNotification.fromJson(Map<String, dynamic> json) => PushNotification(
        title: json["title"],
        body: json["body"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
    };
}