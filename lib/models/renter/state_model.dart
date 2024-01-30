import 'dart:convert';

class StateModel {
    final int? statusCode;
    final String? status;
    final List<StateData>? data;

    StateModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory StateModel.fromRawJson(String str) => StateModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<StateData>.from(json["data"]!.map((x) => StateData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class StateData {
    final String? stateCode;
    final String? stateName;

    StateData({
        this.stateCode,
        this.stateName,
    });

    factory StateData.fromRawJson(String str) => StateData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory StateData.fromJson(Map<String, dynamic> json) => StateData(
        stateCode: json["stateCode"],
        stateName: json["stateName"],
    );

    Map<String, dynamic> toJson() => {
        "stateCode": stateCode,
        "stateName": stateName,
    };
}
