// To parse this JSON data, do
//
//     final vehicleBrandModel = vehicleBrandModelFromJson(jsonString);

import 'dart:convert';

VehicleBrandModel vehicleBrandModelFromJson(String str) => VehicleBrandModel.fromJson(json.decode(str));

String vehicleBrandModelToJson(VehicleBrandModel data) => json.encode(data.toJson());

class VehicleBrandModel {
    final int? statusCode;
    final String? status;
    final List<VehicleBrandData>? data;

    VehicleBrandModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory VehicleBrandModel.fromJson(Map<String, dynamic> json) => VehicleBrandModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<VehicleBrandData>.from(json["data"]!.map((x) => VehicleBrandData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class VehicleBrandData {
    final String? brandCode;
    final String? brandName;

    VehicleBrandData({
        this.brandCode,
        this.brandName,
    });

    factory VehicleBrandData.fromJson(Map<String, dynamic> json) => VehicleBrandData(
        brandCode: json["brandCode"],
        brandName: json["brandName"],
    );

    Map<String, dynamic> toJson() => {
        "brandCode": brandCode,
        "brandName": brandName,
    };
}
