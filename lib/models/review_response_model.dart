import 'dart:convert';

class ReviewResponseModel {
    final int? statusCode;
    final String? status;
    final List<ReviewData>? data;

    ReviewResponseModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory ReviewResponseModel.fromRawJson(String str) => ReviewResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ReviewResponseModel.fromJson(Map<String, dynamic> json) => ReviewResponseModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<ReviewData>.from(json["data"]!.map((x) => ReviewData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class ReviewData {
    final dynamic reviewId;
    final Cleanliness? cleanliness;
    final dynamic cleanlinessPercentage;
    final Cleanliness? roadTardiness;
    final dynamic roadTardinessPercentage;
    final Cleanliness? convenience;
    final dynamic conveniencePercentage;
    final Cleanliness? maintenance;
    final dynamic maintenancePercentage;
    final Cleanliness? point;
    final dynamic pointPercentage;
    final dynamic message;
    final dynamic reviewPercentage;
    final DateTime? createdAt;
    final User? user;

    ReviewData({
        this.reviewId,
        this.cleanliness,
        this.cleanlinessPercentage,
        this.roadTardiness,
        this.roadTardinessPercentage,
        this.convenience,
        this.conveniencePercentage,
        this.maintenance,
        this.maintenancePercentage,
        this.point,
        this.pointPercentage,
        this.message,
        this.reviewPercentage,
        this.createdAt,
        this.user,
    });

    factory ReviewData.fromRawJson(String str) => ReviewData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        reviewId: json["reviewID"],
        cleanliness: cleanlinessValues.map[json["cleanliness"]]!,
        cleanlinessPercentage: json["cleanlinessPercentage"],
        roadTardiness: cleanlinessValues.map[json["roadTardiness"]]!,
        roadTardinessPercentage: json["roadTardinessPercentage"],
        convenience: cleanlinessValues.map[json["convenience"]]!,
        conveniencePercentage: json["conveniencePercentage"],
        maintenance: cleanlinessValues.map[json["maintenance"]]!,
        maintenancePercentage: json["maintenancePercentage"],
        point: cleanlinessValues.map[json["point"]]!,
        pointPercentage: json["pointPercentage"],
        message: json["message"],
        reviewPercentage: json["reviewPercentage"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "reviewID": reviewId,
        "cleanliness": cleanlinessValues.reverse[cleanliness],
        "cleanlinessPercentage": cleanlinessPercentage,
        "roadTardiness": cleanlinessValues.reverse[roadTardiness],
        "roadTardinessPercentage": roadTardinessPercentage,
        "convenience": cleanlinessValues.reverse[convenience],
        "conveniencePercentage": conveniencePercentage,
        "maintenance": cleanlinessValues.reverse[maintenance],
        "maintenancePercentage": maintenancePercentage,
        "point": cleanlinessValues.reverse[point],
        "pointPercentage": pointPercentage,
        "message": message,
        "reviewPercentage": reviewPercentage,
        "createdAt": createdAt?.toIso8601String(),
        "user": user?.toJson(),
    };
}

enum Cleanliness {
    DISLIKE,
    LIKE,
    UN_LIKE
}

final cleanlinessValues = EnumValues({
    "dislike": Cleanliness.DISLIKE,
    "like": Cleanliness.LIKE,
    "unLike": Cleanliness.UN_LIKE
});

class User {
    final dynamic userId;
    final dynamic userName;
    final dynamic userProfileUrl;

    User({
        this.userId,
        this.userName,
        this.userProfileUrl,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userID"]!,
        userName: json["userName"]!,
        userProfileUrl: json["userProfileUrl"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "userName": userName,
        "userProfileUrl": userProfileUrl,
    };
}

// enum UserId {
//     M5_A0_SK
// }

// final userIdValues = EnumValues({
//     "m5a0sk": UserId.M5_A0_SK
// });

// enum UserName {
//     JOHN_MADUKA_O
// }

// final userNameValues = EnumValues({
//     "John Maduka O": UserName.JOHN_MADUKA_O
// });

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
