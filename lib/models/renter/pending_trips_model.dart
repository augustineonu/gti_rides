import 'dart:convert';

class AllTripsRenterModel {
    final int? statusCode;
    final String? status;
    final List<AllTripsData>? data;

    AllTripsRenterModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory AllTripsRenterModel.fromRawJson(String str) => AllTripsRenterModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AllTripsRenterModel.fromJson(Map<String, dynamic> json) => AllTripsRenterModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<AllTripsData>.from(json["data"]!.map((x) => AllTripsData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class AllTripsData {
    final dynamic tripId;
    final dynamic adminStatus;
    final dynamic carId;
    final dynamic status;
    final dynamic totalFee;
    final DateTime? tripEndDate;
    final DateTime? tripStartDate;
    final dynamic tripType;
    final List<AllTripOrder>? tripOrders;
    final dynamic carProfilePic;
    final dynamic carModel;
    final dynamic carYear;
    final dynamic carBrand;

    AllTripsData({
        this.tripId,
        this.adminStatus,
        this.carId,
        this.status,
        this.totalFee,
        this.tripEndDate,
        this.tripStartDate,
        this.tripType,
        this.tripOrders,
        this.carProfilePic,
        this.carModel,
        this.carYear,
        this.carBrand,
    });

    factory AllTripsData.fromRawJson(String str) => AllTripsData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AllTripsData.fromJson(Map<String, dynamic> json) => AllTripsData(
        tripId: json["tripID"],
        adminStatus: json["adminStatus"],
        carId: json["carID"],
        status: json["status"],
        totalFee: json["totalFee"],
        tripEndDate: json["tripEndDate"] == null ? null : DateTime.parse(json["tripEndDate"]),
        tripStartDate: json["tripStartDate"] == null ? null : DateTime.parse(json["tripStartDate"]),
        tripType: json["tripType"],
        tripOrders: json["tripOrders"] == null ? [] : List<AllTripOrder>.from(json["tripOrders"]!.map((x) => AllTripOrder.fromJson(x))),
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
        "tripOrders": tripOrders == null ? [] : List<dynamic>.from(tripOrders!.map((x) => x.toJson())),
        "carProfilePic": carProfilePic,
        "carModel": carModel,
        "carYear": carYear,
        "carBrand": carBrand,
    };
}

class AllTripOrder {
    final dynamic dropOffFee;
    final dynamic escortFee;
    final dynamic paymentLink;
    final dynamic paymentReference;
    final dynamic paymentStatus;
    final dynamic pickUpFee;
    final dynamic pricePerDay;
    final dynamic? totalFee;
    final DateTime? tripEndDate;
    final DateTime? tripStartDate;
    final dynamic tripsDays;
    final dynamic vatFee;

    AllTripOrder({
        this.dropOffFee,
        this.escortFee,
        this.paymentLink,
        this.paymentReference,
        this.paymentStatus,
        this.pickUpFee,
        this.pricePerDay,
        this.totalFee,
        this.tripEndDate,
        this.tripStartDate,
        this.tripsDays,
        this.vatFee,
    });

    factory AllTripOrder.fromRawJson(String str) => AllTripOrder.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AllTripOrder.fromJson(Map<String, dynamic> json) => AllTripOrder(
        dropOffFee: json["dropOffFee"],
        escortFee: json["escortFee"],
        paymentLink: json["paymentLink"],
        paymentReference: json["paymentReference"],
        paymentStatus: json["paymentStatus"],
        pickUpFee: json["pickUpFee"],
        pricePerDay: json["pricePerDay"],
        totalFee: json["totalFee"],
        tripEndDate: json["tripEndDate"] == null ? null : DateTime.parse(json["tripEndDate"]),
        tripStartDate: json["tripStartDate"] == null ? null : DateTime.parse(json["tripStartDate"]),
        tripsDays: json["tripsDays"],
        vatFee: json["vatFee"],
    );

    Map<String, dynamic> toJson() => {
        "dropOffFee": dropOffFee,
        "escortFee": escortFee,
        "paymentLink": paymentLink,
        "paymentReference": paymentReference,
        "paymentStatus": paymentStatus,
        "pickUpFee": pickUpFee,
        "pricePerDay": pricePerDay,
        "totalFee": totalFee,
        "tripEndDate": tripEndDate?.toIso8601String(),
        "tripStartDate": tripStartDate?.toIso8601String(),
        "tripsDays": tripsDays,
        "vatFee": vatFee,
    };
}
