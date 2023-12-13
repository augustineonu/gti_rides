// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TokenModel tokenModelFromJson(String str) => TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
    final String? userType;
    final String? accessToken;

    TokenModel({
         this.userType,
         this.accessToken,
    });

    factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        userType: json["userType"],
        accessToken: json["accessToken"],
    );

    Map<String, dynamic> toJson() => {
        "userType": userType,
        "accessToken": accessToken,
    };
}
