
import 'dart:convert';

class ApiResponseModel {
    final dynamic status_code;
    final String status;
    final String? message;
    final dynamic data;

    ApiResponseModel({
        required this.status_code,
        required this.status,
        required this.message,
        required this.data,
    });

    factory ApiResponseModel.fromRawJson(String str) => ApiResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ApiResponseModel.fromJson(Map<String, dynamic> json) => ApiResponseModel(
        status_code: json["status_code"],
        status: json["status"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "status_code": status_code,
        "status": status,
        "message": message,
        "data": data,
    };
}





// import 'dart:convert';

// ApiResponseModel apiResponseModelFromJson(String str) =>
//     ApiResponseModel.fromJson(json.decode(str));

// String apiResponseModelToJson(ApiResponseModel data) =>
//     json.encode(data.toJson());

// class ApiResponseModel {
//   final int status_code;
//   final String? status;
//   final String? message;
//   final dynamic data;
//   // final dynamic data;

//   ApiResponseModel({
//     required this.status_code,
//     required this.status,
//     required this.message,
//     this.data,
//   });

//   factory ApiResponseModel.fromJson(Map<String, dynamic> json, ) =>
//       ApiResponseModel(
//         status_code: json["status_code"],
//         status: json["status"],
//         message: json["message"],
//         // data: json["data"],
//         data: json['data'] as dynamic,
//       );


//   Map<String, dynamic> toJson() => {
//         "status_code": status_code,
//         "status": status,
//         "message": message,
//         "data": data!,
//       };
// }

