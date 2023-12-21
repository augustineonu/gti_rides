// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final String? userId;
    final String? emailAddress;
    final String ?fullName;
    final String? phoneNumber;
    final String? profilePic;
    final String? referralCode;
    final DateTime? registerDate;
    final String? userType;
    final String? status;

    UserModel({
         this.userId,
         this.emailAddress,
         this.fullName,
         this.phoneNumber,
         this.profilePic,
         this.referralCode,
         this.registerDate,
         this.userType,
         this.status
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userID"],
        emailAddress: json["emailAddress"],
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
        profilePic: json["profilePic"],
        referralCode: json["referralCode"],
        registerDate: DateTime.parse(json["registerDate"]),
        userType: json["userType"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "emailAddress": emailAddress,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "profilePic": profilePic,
        "referralCode": referralCode,
        "registerDate": registerDate?.toIso8601String(),
        "userType": userType,
        "status": status
    };
}
