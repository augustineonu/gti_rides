// To parse this JSON data, do
//
//     final brandModel = brandModelFromJson(jsonString);

import 'dart:convert';

BrandModel brandModelFromJson(String str) => BrandModel.fromJson(json.decode(str));

String brandModelToJson(BrandModel data) => json.encode(data.toJson());

class BrandModel {
    final int? statusCode;
    final String? status;
    final List<BrandModelData>? data;

    BrandModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<BrandModelData>.from(json["data"]!.map((x) => BrandModelData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class BrandModelData {
    final String? modelCode;
    final String? brandCode;
    final String? modelName;

    BrandModelData({
        this.modelCode,
        this.brandCode,
        this.modelName,
    });

    factory BrandModelData.fromJson(Map<String, dynamic> json) => BrandModelData(
        modelCode: json["modelCode"],
        brandCode: json["brandCode"],
        modelName: json["modelName"],
    );

    Map<String, dynamic> toJson() => {
        "modelCode": modelCode,
        "brandCode": brandCode,
        "modelName": modelName,
    };
}
