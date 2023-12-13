// To parse this JSON data, do
//
//     final switchProfileModel = switchProfileModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SwitchProfileModel switchProfileModelFromJson(String str) => SwitchProfileModel.fromJson(json.decode(str));

String switchProfileModelToJson(SwitchProfileModel data) => json.encode(data.toJson());

class SwitchProfileModel {
    final String userType;

    SwitchProfileModel({
        required this.userType,
    });

    factory SwitchProfileModel.fromJson(Map<String, dynamic> json) => SwitchProfileModel(
        userType: json["userType"],
    );

    Map<String, dynamic> toJson() => {
        "userType": userType,
    };
}
