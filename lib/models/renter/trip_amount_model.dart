import 'dart:convert';

class TripAmount {
    final int? statusCode;
    final String? status;
    final List<TripAmountData>? data;

    TripAmount({
        this.statusCode,
        this.status,
        this.data,
    });

    factory TripAmount.fromRawJson(String str) => TripAmount.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TripAmount.fromJson(Map<String, dynamic> json) => TripAmount(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<TripAmountData>.from(json["data"]!.map((x) => TripAmountData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class TripAmountData {
    final String? cautionFee;
    final String? dropOffFee;
    final String? escortFee;
    final String? pickUp;
    final String? vatValue;

    TripAmountData({
        this.cautionFee,
        this.dropOffFee,
        this.escortFee,
        this.pickUp,
        this.vatValue,
    });

    factory TripAmountData.fromRawJson(String str) => TripAmountData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TripAmountData.fromJson(Map<String, dynamic> json) => TripAmountData(
        cautionFee: json["cautionFee"],
        dropOffFee: json["dropOffFee"],
        escortFee: json["escortFee"],
        pickUp: json["pickUp"],
        vatValue: json["vatValue"],
    );

    Map<String, dynamic> toJson() => {
        "cautionFee": cautionFee,
        "dropOffFee": dropOffFee,
        "escortFee": escortFee,
        "pickUp": pickUp,
        "vatValue": vatValue,
    };
}
