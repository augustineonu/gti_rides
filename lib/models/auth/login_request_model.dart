// To parse this JSON data, do
//
//     final loginRequestModel = loginRequestModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) => LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) => json.encode(data.toJson());

class LoginRequestModel {
    final String user;
    final String password;

    LoginRequestModel({
        required this.user,
        required this.password,
    });

    factory LoginRequestModel.fromJson(Map<String, dynamic> json) => LoginRequestModel(
        user: json["user"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "password": password,
    };
}
