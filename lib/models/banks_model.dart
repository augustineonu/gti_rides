// To parse this JSON data, do
//
//     final banksModel = banksModelFromJson(jsonString);

import 'dart:convert';

BanksModel banksModelFromJson(String str) => BanksModel.fromJson(json.decode(str));

String banksModelToJson(BanksModel data) => json.encode(data.toJson());

class BanksModel {
    final String id;
    final String name;
    final String code;

    BanksModel({
        required this.id,
        required this.name,
        required this.code,
    });

    factory BanksModel.fromJson(Map<String, dynamic> json) => BanksModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
    };
}
