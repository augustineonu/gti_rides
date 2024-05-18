// To parse this JSON data, do
//
//     final vehicleYearModel = vehicleYearModelFromJson(jsonString);

import 'dart:convert';

VehicleYearModel vehicleYearModelFromJson(String str) => VehicleYearModel.fromJson(json.decode(str));

String vehicleYearModelToJson(VehicleYearModel data) => json.encode(data.toJson());

class VehicleYearModel {
    final int? statusCode;
    final String? status;
    final List<VehicleYearData>? data;

    VehicleYearModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory VehicleYearModel.fromJson(Map<String, dynamic> json) => VehicleYearModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<VehicleYearData>.from(json["data"]!.map((x) => VehicleYearData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class VehicleYearData {
    final String? yearCode;
    final String? advicePrice;
    final String? brandCode;
    final String? brandModelCode;
    final String? yearName;

    VehicleYearData({
        this.yearCode,
        this.advicePrice,
        this.brandCode,
        this.brandModelCode,
        this.yearName,
    });

    factory VehicleYearData.fromJson(Map<String, dynamic> json) => VehicleYearData(
        yearCode: json["yearCode"],
        advicePrice: json["advicePrice"],
        brandCode: json["brandCode"],
        brandModelCode: json["brandModelCode"],
        yearName: json["yearName"],
    );

    Map<String, dynamic> toJson() => {
        "yearCode": yearCode,
        "advicePrice": advicePrice,
        "brandCode": brandCode,
        "brandModelCode": brandModelCode,
        "yearName": yearName,
    };
}
