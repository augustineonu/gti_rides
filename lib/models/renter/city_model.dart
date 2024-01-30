import 'dart:convert';

class CityModel {
    final int? statusCode;
    final String? status;
    final List<CityData>? data;

    CityModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory CityModel.fromRawJson(String str) => CityModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<CityData>.from(json["data"]!.map((x) => CityData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class CityData {
    final String? cityCode;
    final String? stateCode;
    final String? cityName;

    CityData({
        this.cityCode,
        this.stateCode,
        this.cityName,
    });

    factory CityData.fromRawJson(String str) => CityData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CityData.fromJson(Map<String, dynamic> json) => CityData(
        cityCode: json["cityCode"],
        stateCode: json["stateCode"],
        cityName: json["cityName"],
    );

    Map<String, dynamic> toJson() => {
        "cityCode": cityCode,
        "stateCode": stateCode,
        "cityName": cityName,
    };
}
