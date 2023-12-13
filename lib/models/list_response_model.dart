import 'dart:convert';

class ListResponseModel {
    final int status_code;
    final String status;
    final dynamic data;

    ListResponseModel({
        required this.status_code,
        required this.status,
        required this.data,
    });

    factory ListResponseModel.fromRawJson(String str) => ListResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ListResponseModel.fromJson(Map<String, dynamic> json) => ListResponseModel(
        status_code: json["status_code"],
        status: json["status"],
        // data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
        data: json["data"] as dynamic,
    );

    Map<String, dynamic> toJson() => {
        "status_code": status_code,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class User {
    final String userId;
    final String emailAddress;
    final String fullName;
    final String phoneNumber;
    final String profilePic;
    final String referralCode;
    final DateTime registerDate;
    final String userType;

    User({
        required this.userId,
        required this.emailAddress,
        required this.fullName,
        required this.phoneNumber,
        required this.profilePic,
        required this.referralCode,
        required this.registerDate,
        required this.userType,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userID"],
        emailAddress: json["emailAddress"],
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
        profilePic: json["profilePic"],
        referralCode: json["referralCode"],
        registerDate: DateTime.parse(json["registerDate"]),
        userType: json["userType"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "emailAddress": emailAddress,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "profilePic": profilePic,
        "referralCode": referralCode,
        "registerDate": registerDate.toIso8601String(),
        "userType": userType,
    };
}
