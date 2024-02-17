import 'dart:convert';

class PendingTripsModel {
    final int? statusCode;
    final String? status;
    final List<PendingTripsData>? data;

    PendingTripsModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory PendingTripsModel.fromRawJson(String str) => PendingTripsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PendingTripsModel.fromJson(Map<String, dynamic> json) => PendingTripsModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<PendingTripsData>.from(json["data"]!.map((x) => PendingTripsData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class PendingTripsData {
    final dynamic tripId;
    final dynamic carId;
    final dynamic status;
    final DateTime? tripEndDate;
    final DateTime? tripStartDate;
    final dynamic tripType;
    final dynamic totalFee;
    final dynamic adminStatus;
    final dynamic carProfilePic;
    final dynamic carModel;
    final dynamic carYear;
    final dynamic carBrand;

    PendingTripsData({
        this.tripId,
        this.carId,
        this.status,
        this.tripEndDate,
        this.tripStartDate,
        this.tripType,
        this.totalFee,
        this.adminStatus,
        this.carProfilePic,
        this.carModel,
        this.carYear,
        this.carBrand,
    });

    factory PendingTripsData.fromRawJson(String str) => PendingTripsData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PendingTripsData.fromJson(Map<String, dynamic> json) => PendingTripsData(
        tripId: json["tripID"],
        carId: json["carID"],
        status: json["status"],
        tripEndDate: json["tripEndDate"] == null ? null : DateTime.parse(json["tripEndDate"]),
        tripStartDate: json["tripStartDate"] == null ? null : DateTime.parse(json["tripStartDate"]),
        tripType: json["tripType"],
        totalFee: json["totalFee"],
        adminStatus: json["adminStatus"],
        carProfilePic: json["carProfilePic"],
        carModel: json["carModel"],
        carYear: json["carYear"],
        carBrand: json["carBrand"],
    );

    Map<String, dynamic> toJson() => {
        "tripID": tripId,
        "carID": carId,
        "status": status,
        "tripEndDate": "${tripEndDate!.year.toString().padLeft(4, '0')}-${tripEndDate!.month.toString().padLeft(2, '0')}-${tripEndDate!.day.toString().padLeft(2, '0')}",
        "tripStartDate": "${tripStartDate!.year.toString().padLeft(4, '0')}-${tripStartDate!.month.toString().padLeft(2, '0')}-${tripStartDate!.day.toString().padLeft(2, '0')}",
        "tripType": tripType,
        "totalFee": totalFee,
        "adminStatus": adminStatus,
        "carProfilePic": carProfilePic,
        "carModel": carModel,
        "carYear": carYear,
        "carBrand": carBrand,
    };
}
