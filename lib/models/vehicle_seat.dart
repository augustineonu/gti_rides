// To parse this JSON data, do
//
//     final vehicleSeatModel = vehicleSeatModelFromJson(jsonString);

import 'dart:convert';

VehicleSeatModel vehicleSeatModelFromJson(String str) => VehicleSeatModel.fromJson(json.decode(str));

String vehicleSeatModelToJson(VehicleSeatModel data) => json.encode(data.toJson());

class VehicleSeatModel {
    final int? statusCode;
    final String? status;
    final List<VehicleSeatData>? data;

    VehicleSeatModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory VehicleSeatModel.fromJson(Map<String, dynamic> json) => VehicleSeatModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<VehicleSeatData>.from(json["data"]!.map((x) => VehicleSeatData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class VehicleSeatData {
    final String? seatCode;
    final String? seatName;

    VehicleSeatData({
        this.seatCode,
        this.seatName,
    });

    factory VehicleSeatData.fromJson(Map<String, dynamic> json) => VehicleSeatData(
        seatCode: json["seatCode"],
        seatName: json["seatName"],
    );

    Map<String, dynamic> toJson() => {
        "seatCode": seatCode,
        "seatName": seatName,
    };
}
