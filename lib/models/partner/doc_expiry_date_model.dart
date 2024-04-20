// To parse this JSON data, do
//
//     final carDocExpiryDate = carDocExpiryDateFromJson(jsonString);

import 'dart:convert';

List<CarDocExpiryDate> carDocExpiryDateFromJson(String str) => List<CarDocExpiryDate>.from(json.decode(str).map((x) => CarDocExpiryDate.fromJson(x)));

String carDocExpiryDateToJson(List<CarDocExpiryDate> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarDocExpiryDate {
    final String? documentName;
    final DateTime? expireDate;

    CarDocExpiryDate({
        this.documentName,
        this.expireDate,
    });

    factory CarDocExpiryDate.fromJson(Map<String, dynamic> json) => CarDocExpiryDate(
        documentName: json["documentName"],
        expireDate: json["expireDate"] == null ? null : DateTime.parse(json["expireDate"]),
    );

    Map<String, dynamic> toJson() => {
        "documentName": documentName,
        "expireDate": "${expireDate!.year.toString().padLeft(4, '0')}-${expireDate!.month.toString().padLeft(2, '0')}-${expireDate!.day.toString().padLeft(2, '0')}",
    };
}
