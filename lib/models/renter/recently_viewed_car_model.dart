

import 'dart:convert';

class RecentCarsModel {
    final int? statusCode;
    final String? status;
    final List<RecentCar>? data;

    RecentCarsModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory RecentCarsModel.fromRawJson(String str) => RecentCarsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RecentCarsModel.fromJson(Map<String, dynamic> json) => RecentCarsModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<RecentCar>.from(json["data"]!.map((x) => RecentCar.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class RecentCar {
    final dynamic carId;
    final dynamic brandName;
    final dynamic brandModelName;
    final dynamic status;
    final dynamic pricePerDay;
    final dynamic availability;
    final dynamic startDate;
    final dynamic endDate;
    final dynamic photoUrl;
    final dynamic tripsCount;
    final dynamic percentageRate;

    RecentCar({
        this.carId,
        this.brandName,
        this.brandModelName,
        this.status,
        this.pricePerDay,
        this.availability,
        this.startDate,
        this.endDate,
        this.photoUrl,
        this.tripsCount,
        this.percentageRate,
    });

    factory RecentCar.fromRawJson(String str) => RecentCar.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RecentCar.fromJson(Map<String, dynamic> json) => RecentCar(
        carId: json["carID"],
        brandName: json["brandName"],
        brandModelName: json["brandModelName"],
        status: json["status"],
        pricePerDay: json["pricePerDay"],
        availability: json["availability"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        photoUrl: json["photoUrl"],
        tripsCount: json["tripsCount"],
        percentageRate: json["percentageRate"],
    );

    Map<String, dynamic> toJson() => {
        "carID": carId,
        "brandName": brandName,
        "brandModelName": brandModelName,
        "status": status,
        "pricePerDay": pricePerDay,
        "availability": availability,
        "startDate": startDate,
        "endDate": endDate,
        "photoUrl": photoUrl,
        "tripsCount": tripsCount,
        "percentageRate": percentageRate,
    };
}



// import 'dart:convert';

class RecentlyViewCarModel {
  final String imageUrl;
  final String carModel;
  final String ratings;
  final String trips;
  final String pricePerDay;
  RecentlyViewCarModel( {
    required this.imageUrl,
    required this.carModel,
    required this.ratings,
    required this.trips,
    required this.pricePerDay,
  });

  RecentlyViewCarModel copyWith({
    String? imageUrl,
    String? carModel,
    String? ratings,
    String? trips,
    String? pricePerDay,
  }) {
    return RecentlyViewCarModel(
      imageUrl: imageUrl ?? this.imageUrl,
      carModel: carModel ?? this.carModel,
      ratings: ratings ?? this.ratings,
      trips: trips ?? this.trips,
      pricePerDay: pricePerDay ?? this.pricePerDay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageUrl': imageUrl,
      'carModel': carModel,
      'ratings': ratings,
      'trips': trips,
      'pricePerDay': pricePerDay,
    };
  }

  factory RecentlyViewCarModel.fromMap(Map<String, dynamic> map) {
    return RecentlyViewCarModel(
      imageUrl: map['imageUrl'] as String,
      carModel: map['carModel'] as String,
      ratings: map['ratings'] as String,
      trips: map['trips'] as String,
      pricePerDay: map['pricePerDay'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecentlyViewCarModel.fromJson(String source) => RecentlyViewCarModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecentlyViewCarModel(imageUrl: $imageUrl, carModel: $carModel, ratings: $ratings, trips: $trips, pricePerDay: $pricePerDay)';
  }

  @override
  bool operator ==(covariant RecentlyViewCarModel other) {
    if (identical(this, other)) return true;
  
    return 
    other.imageUrl == imageUrl &&
      other.carModel == carModel &&
      other.ratings == ratings &&
      other.trips == trips &&
      other.pricePerDay == pricePerDay;
  }

  @override
  int get hashCode {
    return imageUrl.hashCode ^
    carModel.hashCode ^
      ratings.hashCode ^
      trips.hashCode ^
      pricePerDay.hashCode;
  }
}
