import 'dart:convert';

class KycResponseModel {
    final int? statusCode;
    final String? status;
    final List<KycData>? data;

    KycResponseModel({
        this.statusCode,
        this.status,
        this.data,
    });

    KycResponseModel copyWith({
        int? statusCode,
        String? status,
        List<KycData>? data,
    }) => 
        KycResponseModel(
            statusCode: statusCode ?? this.statusCode,
            status: status ?? this.status,
            data: data ?? this.data,
        );

    factory KycResponseModel.fromRawJson(String str) => KycResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory KycResponseModel.fromJson(Map<String, dynamic> json) => KycResponseModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<KycData>.from(json["data"]!.map((x) => KycData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class KycData {
    final String? dateOfBirth;
    final String? emergencyName;
    final String? emergencyNumber;
    final String? emergencyRelationship;
    final String? gender;
    final String? homeAddress;
    final String? occupation;
    final String? officeAddress;
    final String? licenceExpireDate;
    final String? licenceNumber;
    final String? homeAddressProof;

    KycData({
        this.dateOfBirth,
        this.emergencyName,
        this.emergencyNumber,
        this.emergencyRelationship,
        this.gender,
        this.homeAddress,
        this.occupation,
        this.officeAddress,
        this.licenceExpireDate,
        this.licenceNumber,
        this.homeAddressProof,
    });

    KycData copyWith({
        String? dateOfBirth,
        String? emergencyName,
        String? emergencyNumber,
        String? emergencyRelationship,
        String? gender,
        String? homeAddress,
        String? occupation,
        String? officeAddress,
        String? licenceExpireDate,
        String? licenceNumber,
        String? homeAddressProof,
    }) => 
        KycData(
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            emergencyName: emergencyName ?? this.emergencyName,
            emergencyNumber: emergencyNumber ?? this.emergencyNumber,
            emergencyRelationship: emergencyRelationship ?? this.emergencyRelationship,
            gender: gender ?? this.gender,
            homeAddress: homeAddress ?? this.homeAddress,
            occupation: occupation ?? this.occupation,
            officeAddress: officeAddress ?? this.officeAddress,
            licenceExpireDate: licenceExpireDate ?? this.licenceExpireDate,
            licenceNumber: licenceNumber ?? this.licenceNumber,
            homeAddressProof: homeAddressProof ?? this.homeAddressProof,
        );

    factory KycData.fromRawJson(String str) => KycData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory KycData.fromJson(Map<String, dynamic> json) => KycData(
        dateOfBirth: json["dateOfBirth"],
        emergencyName: json["emergencyName"],
        emergencyNumber: json["emergencyNumber"],
        emergencyRelationship: json["emergencyRelationship"],
        gender: json["gender"],
        homeAddress: json["homeAddress"],
        occupation: json["occupation"],
        officeAddress: json["officeAddress"],
        licenceExpireDate: json["licenceExpireDate"],
        licenceNumber: json["licenceNumber"],
        homeAddressProof: json["homeAddressProof"],
    );

    Map<String, dynamic> toJson() => {
        "dateOfBirth": dateOfBirth,
        "emergencyName": emergencyName,
        "emergencyNumber": emergencyNumber,
        "emergencyRelationship": emergencyRelationship,
        "gender": gender,
        "homeAddress": homeAddress,
        "occupation": occupation,
        "officeAddress": officeAddress,
        "licenceExpireDate": licenceExpireDate,
        "licenceNumber": licenceNumber,
        "homeAddressProof": homeAddressProof,
    };
}
