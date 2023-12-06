// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApiResponseModel {
  final dynamic status_code;
  final String status;
  final String message;
  final dynamic data;

  ApiResponseModel({required 
  this.status_code, required this.status, 
  required this.message, this.data});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status_code': status_code,
      'status': status,
      'message': message,
      'data': data,
    };
  }

  factory ApiResponseModel.fromMap(Map<String, dynamic> map) {
    return ApiResponseModel(
      status_code: map['status_code'] as dynamic,
      status: map['status'] as String,
      message: map['message'] as String,
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponseModel.fromJson(String source) => ApiResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ApiResponseModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.status_code == status_code &&
      other.status == status &&
      other.message == message &&
      other.data == data;
  }

  @override
  int get hashCode {
    return status_code.hashCode ^
      status.hashCode ^
      message.hashCode ^
      data.hashCode;
  }
}
