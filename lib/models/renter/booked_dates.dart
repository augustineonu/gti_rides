import 'dart:convert';

class BookedDatesModel {
    final int? statusCode;
    final String? status;
    final List<BookedData>? data;

    BookedDatesModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory BookedDatesModel.fromRawJson(String str) => BookedDatesModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BookedDatesModel.fromJson(Map<String, dynamic> json) => BookedDatesModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<BookedData>.from(json["data"]!.map((x) => BookedData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class BookedData {
    final dynamic tripId;
    final dynamic adminStatus;
    final dynamic carId;
    final dynamic status;
    final dynamic totalFee;
    final DateTime? tripEndDate;
    final DateTime? tripStartDate;
    final dynamic tripType;
    final dynamic carProfilePic;
    final dynamic carModel;
    final dynamic carYear;
    final dynamic carBrand;

    BookedData({
        this.tripId,
        this.adminStatus,
        this.carId,
        this.status,
        this.totalFee,
        this.tripEndDate,
        this.tripStartDate,
        this.tripType,
        this.carProfilePic,
        this.carModel,
        this.carYear,
        this.carBrand,
    });

    factory BookedData.fromRawJson(String str) => BookedData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BookedData.fromJson(Map<String, dynamic> json) => BookedData(
        tripId: json["tripID"],
        adminStatus: json["adminStatus"],
        carId: json["carID"],
        status: json["status"],
        totalFee: json["totalFee"],
        tripEndDate: json["tripEndDate"] == null ? null : DateTime.parse(json["tripEndDate"]),
        tripStartDate: json["tripStartDate"] == null ? null : DateTime.parse(json["tripStartDate"]),
        tripType: json["tripType"],
        carProfilePic: json["carProfilePic"],
        carModel: json["carModel"],
        carYear: json["carYear"],
        carBrand: json["carBrand"],
    );

    Map<String, dynamic> toJson() => {
        "tripID": tripId,
        "adminStatus": adminStatus,
        "carID": carId,
        "status": status,
        "totalFee": totalFee,
        "tripEndDate": tripEndDate?.toIso8601String(),
        "tripStartDate": tripStartDate?.toIso8601String(),
        "tripType": tripType,
        "carProfilePic": carProfilePic,
        "carModel": carModel,
        "carYear": carYear,
        "carBrand": carBrand,
    };
}
