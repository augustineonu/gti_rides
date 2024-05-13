// To parse this JSON data, do
//
//     final carFeaturesModel = carFeaturesModelFromJson(jsonString);

import 'dart:convert';

CarFeaturesModel carFeaturesModelFromJson(String str) => CarFeaturesModel.fromJson(json.decode(str));

String carFeaturesModelToJson(CarFeaturesModel data) => json.encode(data.toJson());

class CarFeaturesModel {
    final int? statusCode;
    final String? status;
    final List<CarFeatureData>? data;

    CarFeaturesModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory CarFeaturesModel.fromJson(Map<String, dynamic> json) => CarFeaturesModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<CarFeatureData>.from(json["data"]!.map((x) => CarFeatureData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class CarFeatureData {
    final String? featuresCode;
    final String? featuresName;

    CarFeatureData({
        this.featuresCode,
        this.featuresName,
    });

    factory CarFeatureData.fromJson(Map<String, dynamic> json) => CarFeatureData(
        featuresCode: json["featuresCode"],
        featuresName: json["featuresName"],
    );

    Map<String, dynamic> toJson() => {
        "featuresCode": featuresCode,
        "featuresName": featuresName,
    };
}
