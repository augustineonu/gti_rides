// To parse this JSON data, do
//
//     final vehicleTypeModel = vehicleTypeModelFromJson(jsonString);

import 'dart:convert';

VehicleTypeModel vehicleTypeModelFromJson(String str) => VehicleTypeModel.fromJson(json.decode(str));

String vehicleTypeModelToJson(VehicleTypeModel data) => json.encode(data.toJson());

class VehicleTypeModel {
    final int? statusCode;
    final String? status;
    final List<VehicleTypeData>? data;

    VehicleTypeModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => VehicleTypeModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<VehicleTypeData>.from(json["data"]!.map((x) => VehicleTypeData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class VehicleTypeData {
    final String? typeCode;
    final String? typeName;

    VehicleTypeData({
        this.typeCode,
        this.typeName,
    });

    factory VehicleTypeData.fromJson(Map<String, dynamic> json) => VehicleTypeData(
        typeCode: json["typeCode"],
        typeName: json["typeName"],
    );

    Map<String, dynamic> toJson() => {
        "typeCode": typeCode,
        "typeName": typeName,
    };
}
