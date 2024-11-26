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
        final Renter? renter;
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
        this.renter,
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
                renter: json["renter"] == null ? null : Renter.fromJson(json["renter"]),

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
        "renter": renter?.toJson(),
        "carProfilePic": carProfilePic,
        "carModel": carModel,
        "carYear": carYear,
        "carBrand": carBrand,
    };
}

class Renter {
    final String? userId;
    final String? userName;
    final String? userProfileUrl;

    Renter({
        this.userId,
        this.userName,
        this.userProfileUrl,
    });

    factory Renter.fromJson(Map<String, dynamic> json) => Renter(
        userId: json["userID"],
        userName: json["userName"],
        userProfileUrl: json["userProfileUrl"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "userName": userName,
        "userProfileUrl": userProfileUrl,
    };
}

class Payment {
    final String? paymentStatus;
    final String? paymentDate;
    final String? paymentReference;

    Payment({
        this.paymentStatus,
        this.paymentDate,
        this.paymentReference,
    });

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentStatus: json["paymentStatus"],
        paymentDate: json["paymentDate"],
        paymentReference: json["paymentReference"],
    );

    Map<String, dynamic> toJson() => {
        "paymentStatus": paymentStatus,
        "paymentDate": paymentDate,
        "paymentReference": paymentReference,
    };
}


class AllTripOrder {
    final dynamic cautionFee;
    final dynamic discountPerDay;
    final dynamic discountPerDayTotal;
    final dynamic dropOffFee;
    final dynamic escortFee;
    final dynamic paymentLink;
    final dynamic paymentReference;
    final dynamic paymentStatus;
    final dynamic pickUpFee;
    final dynamic pricePerDay;
    final dynamic pricePerDayTotal;
    final dynamic totalFee;
    final DateTime? tripEndDate;
    final DateTime? tripStartDate;
    final dynamic tripsDays;
    final dynamic vatFee;
    final Payment? payment;

    AllTripOrder({
      this.cautionFee,
        this.discountPerDay,
        this.discountPerDayTotal,
        this.dropOffFee,
        this.escortFee,
        this.paymentLink,
        this.paymentReference,
        this.paymentStatus,
        this.pickUpFee,
        this.pricePerDay,
        this.pricePerDayTotal,
        this.totalFee,
        this.tripEndDate,
        this.tripStartDate,
        this.tripsDays,
        this.vatFee,
        this.payment,
    });

    factory AllTripOrder.fromRawJson(String str) => AllTripOrder.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AllTripOrder.fromJson(Map<String, dynamic> json) => AllTripOrder(
        cautionFee: json["cautionFee"],
        discountPerDay: json["discountPerDay"],
        discountPerDayTotal: json["discountPerDayTotal"],
        dropOffFee: json["dropOffFee"],
        escortFee: json["escortFee"],
        paymentLink: json["paymentLink"],
        paymentReference: json["paymentReference"],
        paymentStatus: json["paymentStatus"],
        pickUpFee: json["pickUpFee"],
        pricePerDay: json["pricePerDay"],
        pricePerDayTotal: json["pricePerDayTotal"],
        totalFee: json["totalFee"],
        tripEndDate: json["tripEndDate"] == null ? null : DateTime.parse(json["tripEndDate"]),
        tripStartDate: json["tripStartDate"] == null ? null : DateTime.parse(json["tripStartDate"]),
        tripsDays: json["tripsDays"],
        vatFee: json["vatFee"],
        payment: json["payment"] == null ? null : Payment.fromJson(json["payment"])
    );

    Map<String, dynamic> toJson() => {
      "cautionFee": cautionFee,
        "discountPerDay": discountPerDay,
        "discountPerDayTotal": discountPerDayTotal,
        "dropOffFee": dropOffFee,
        "escortFee": escortFee,
        "paymentLink": paymentLink,
        "paymentReference": paymentReference,
        "paymentStatus": paymentStatus,
        "pickUpFee": pickUpFee,
        "pricePerDay": pricePerDay,
        "pricePerDayTotal": pricePerDayTotal,
        "totalFee": totalFee,
        "tripEndDate": tripEndDate?.toIso8601String(),
        "tripStartDate": tripStartDate?.toIso8601String(),
        "tripsDays": tripsDays,
        "vatFee": vatFee,
        "payment": payment!.toJson(),
    };
}
