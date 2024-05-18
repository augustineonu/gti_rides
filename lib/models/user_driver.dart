// To parse this JSON data, do
//
//     final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

DriverModel driverModelFromJson(String str) => DriverModel.fromJson(json.decode(str));

String driverModelToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
    final int? statusCode;
    final String? status;
    final List<UserDriverData>? data;

    DriverModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<UserDriverData>.from(json["data"]!.map((x) => UserDriverData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class UserDriverData {
    final String? driverId;
    final String? driverEmail;
    final String? driverNumber;
    final String? fullName;
    final String? userId;
    final String? licenceExpireDate;
    final String? licenceFront;
    final String? licenseNumber;
    final String? licenceBack;

    UserDriverData({
        this.driverId,
        this.driverEmail,
        this.driverNumber,
        this.fullName,
        this.userId,
        this.licenceExpireDate,
        this.licenceFront,
        this.licenseNumber,
        this.licenceBack,
    });

    factory UserDriverData.fromJson(Map<String, dynamic> json) => UserDriverData(
        driverId: json["driverID"],
        driverEmail: json["driverEmail"],
        driverNumber: json["driverNumber"],
        fullName: json["fullName"],
        userId: json["userID"],
        licenceExpireDate: json["licenceExpireDate"],
        licenceFront: json["licenceFront"],
        licenseNumber: json["licenseNumber"],
        licenceBack: json["licenceBack"],
    );

    Map<String, dynamic> toJson() => {
        "driverID": driverId,
        "driverEmail": driverEmail,
        "driverNumber": driverNumber,
        "fullName": fullName,
        "userID": userId,
        "licenceExpireDate": licenceExpireDate,
        "licenceFront": licenceFront,
        "licenseNumber": licenseNumber,
        "licenceBack": licenceBack,
    };
}
