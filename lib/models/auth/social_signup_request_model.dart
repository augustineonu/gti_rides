// To parse this JSON data, do
//
//     final socialSignUpRequestModel = socialSignUpRequestModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SocialSignUpRequestModel socialSignUpRequestModelFromJson(String str) => SocialSignUpRequestModel.fromJson(json.decode(str));

String socialSignUpRequestModelToJson(SocialSignUpRequestModel data) => json.encode(data.toJson());

class SocialSignUpRequestModel {
    final String fullName;
    final String emailAddress;
    final String socialType;
    final String socialId;

    SocialSignUpRequestModel({
        required this.fullName,
        required this.emailAddress,
        required this.socialType,
        required this.socialId,
    });

    factory SocialSignUpRequestModel.fromJson(Map<String, dynamic> json) => SocialSignUpRequestModel(
        fullName: json["fullName"],
        emailAddress: json["emailAddress"],
        socialType: json["socialType"],
        socialId: json["socialID"],
    );

    Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "emailAddress": emailAddress,
        "socialType": socialType,
        "socialID": socialId,
    };
}
