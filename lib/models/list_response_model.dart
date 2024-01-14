
import 'dart:convert';

class ListResponseModel {
    final int? status_code;
    final String? status;
    final String? message;
     List<dynamic>? data;

    ListResponseModel({
        this.status_code,
        this.status,
        this.message,
        this.data,
    });

    ListResponseModel copyWith({
        int? status_code,
        String? status,
        String? message,
        List<dynamic>? data,
    }) => 
        ListResponseModel(
            status_code: status_code ?? this.status_code,
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ListResponseModel.fromRawJson(String str) => ListResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ListResponseModel.fromJson(Map<String, dynamic> json) => ListResponseModel(
        status_code: json["status_code"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status_code": status_code,
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    };
}


// import 'dart:convert';

// class ListResponseModel {
//     final int? status_code;
//     final String? status;
//     final dynamic data;

//     ListResponseModel({
//          this.status_code,
//          this.status,
//          this.data,
//     });

//     factory ListResponseModel.fromRawJson(String str) => ListResponseModel.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory ListResponseModel.fromJson(Map<String, dynamic> json) => ListResponseModel(
//         status_code: json["status_code"],
//         status: json["status"],
//         // data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
//         data: json["data"] as dynamic,
//     );

//     Map<String, dynamic> toJson() => {
//         "status_code": status_code,
//         "status": status,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     };
// }

// class User {
//     final String userId;
//     final String emailAddress;
//     final String fullName;
//     final String phoneNumber;
//     final String profilePic;
//     final String referralCode;
//     final DateTime registerDate;
//     final String userType;
//     final String status;

//     User({
//         required this.userId,
//         required this.emailAddress,
//         required this.fullName,
//         required this.phoneNumber,
//         required this.profilePic,
//         required this.referralCode,
//         required this.registerDate,
//         required this.userType,
//         required this.status,
//     });

//     factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory User.fromJson(Map<String, dynamic> json) => User(
//         userId: json["userID"],
//         emailAddress: json["emailAddress"],
//         fullName: json["fullName"],
//         phoneNumber: json["phoneNumber"],
//         profilePic: json["profilePic"],
//         referralCode: json["referralCode"],
//         registerDate: DateTime.parse(json["registerDate"]),
//         userType: json["userType"],
//         status: json["status"],
//     );

//     Map<String, dynamic> toJson() => {
//         "userID": userId,
//         "emailAddress": emailAddress,
//         "fullName": fullName,
//         "phoneNumber": phoneNumber,
//         "profilePic": profilePic,
//         "referralCode": referralCode,
//         "registerDate": registerDate.toIso8601String(),
//         "userType": userType,
//         "status": status,
//     };
// }
