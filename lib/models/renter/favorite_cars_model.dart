import 'dart:convert';

class FvaoriteCarsModel {
    final int? statusCode;
    final String? status;
    final List<FavoriteCarData>? data;

    FvaoriteCarsModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory FvaoriteCarsModel.fromRawJson(String str) => FvaoriteCarsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory FvaoriteCarsModel.fromJson(Map<String, dynamic> json) => FvaoriteCarsModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<FavoriteCarData>.from(json["data"]!.map((x) => FavoriteCarData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class FavoriteCarData {
    final dynamic carId;
    final dynamic brandName;
    final dynamic brandModelName;
    final dynamic status;
    final dynamic pricePerDay;
    final dynamic availability;
    final dynamic startDate;
    final dynamic endDate;
    final dynamic photoUrl;
    final dynamic tripsCount;
    final dynamic percentageRate;

    FavoriteCarData({
        this.carId,
        this.brandName,
        this.brandModelName,
        this.status,
        this.pricePerDay,
        this.availability,
        this.startDate,
        this.endDate,
        this.photoUrl,
        this.tripsCount,
        this.percentageRate,
    });

    factory FavoriteCarData.fromRawJson(String str) => FavoriteCarData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory FavoriteCarData.fromJson(Map<String, dynamic> json) => FavoriteCarData(
        carId: json["carID"],
        brandName: json["brandName"],
        brandModelName: json["brandModelName"],
        status: json["status"],
        pricePerDay: json["pricePerDay"],
        availability: json["availability"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        photoUrl: json["photoUrl"],
        tripsCount: json["tripsCount"],
        percentageRate: json["percentageRate"],
    );

    Map<String, dynamic> toJson() => {
        "carID": carId,
        "brandName": brandName,
        "brandModelName": brandModelName,
        "status": status,
        "pricePerDay": pricePerDay,
        "availability": availability,
        "startDate": startDate,
        "endDate": endDate,
        "photoUrl": photoUrl,
        "tripsCount": tripsCount,
        "percentageRate": percentageRate,
    };
}
