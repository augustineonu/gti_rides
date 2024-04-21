// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    final int? statusCode;
    final String? status;
    final List<NotificationData>? data;

    NotificationModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<NotificationData>.from(json["data"]!.map((x) => NotificationData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class NotificationData {
    final String? notificationId;
    final String? userId;
    final String? notificationType;
    final String? title;
    final String? message;
    final bool? status;
    final DateTime? createdAt;

    NotificationData({
        this.notificationId,
        this.userId,
        this.notificationType,
        this.title,
        this.message,
        this.status,
        this.createdAt,
    });

    factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        notificationId: json["notificationID"],
        userId: json["userID"],
        notificationType: json["notificationType"],
        title: json["title"],
        message: json["message"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "notificationID": notificationId,
        "userID": userId,
        "notificationType": notificationType,
        "title": title,
        "message": message,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
    };
}
