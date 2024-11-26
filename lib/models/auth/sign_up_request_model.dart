// To parse this JSON data, do
//
//     final signUpRequestModel = signUpRequestModelFromJson(jsonString);

import 'dart:convert';

SignUpRequestModel signUpRequestModelFromJson(String str) =>
    SignUpRequestModel.fromJson(json.decode(str));

String signUpRequestModelToJson(SignUpRequestModel data) =>
    json.encode(data.toJson());

class SignUpRequestModel {
  final String fullName;
  final String emailAddress;
  final String phoneNumber;
  final String userType;
   String? referralCode;
  final String password;

  SignUpRequestModel({
    required this.fullName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.userType,
    this.referralCode,
    required this.password,
  });

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) =>
      SignUpRequestModel(
        fullName: json["fullName"],
        emailAddress: json["emailAddress"],
        phoneNumber: json["phoneNumber"],
        userType: json["userType"],
        referralCode: json["referralCode"],
        password: json["password"],
      );

 Map<String, dynamic> toJson() {
  Map<String, dynamic> json = {
    "fullName": fullName,
    "emailAddress": emailAddress,
    "phoneNumber": phoneNumber,
    "userType": userType,
    "password": password,
  };

  // Only include referralCode if it's not null or empty
  if (referralCode != null && referralCode!.isNotEmpty) {
    json["referralCode"] = referralCode;
  }

  return json;
}

}
