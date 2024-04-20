import 'dart:convert';

class CarsModel {
    final int? statusCode;
    final String? status;
    final List<CarData>? data;

    CarsModel({
        this.statusCode,
        this.status,
        this.data,
    });

    factory CarsModel.fromRawJson(String str) => CarsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CarsModel.fromJson(Map<String, dynamic> json) => CarsModel(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<CarData>.from(json["data"]!.map((x) => CarData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class CarData {
    final dynamic carId;
    final dynamic availability;
        final bool? documentExpire;
    final dynamic status;
    final dynamic photoUrl;
    final dynamic endDate;
    final dynamic pricePerDay;
    final dynamic startDate;
    final List<State>? state;
    final List<City>? city;
    final List<Photo>? photo;
    final dynamic brandName;
    final dynamic brandModelName;
    final dynamic tripsCount;
    final dynamic percentageRate;

    CarData({
        this.carId,
        this.availability,
        this.documentExpire,
        this.status,
        this.photoUrl,
        this.endDate,
        this.pricePerDay,
        this.startDate,
        this.state,
        this.city,
        this.photo,
        this.brandName,
        this.brandModelName,
        this.tripsCount,
        this.percentageRate,
    });

    factory CarData.fromRawJson(String str) => CarData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CarData.fromJson(Map<String, dynamic> json) => CarData(
        carId: json["carID"],
        availability: json["availability"],
        documentExpire: json["documentExpire"],
        status: json["status"],
        photoUrl: json["photoUrl"],
        endDate: json["endDate"],
        pricePerDay: json["pricePerDay"],
        startDate: json["startDate"],
        state: json["state"] == null ? [] : List<State>.from(json["state"]!.map((x) => State.fromJson(x))),
        city: json["city"] == null ? [] : List<City>.from(json["city"]!.map((x) => City.fromJson(x))),
        photo: json["photo"] == null ? [] : List<Photo>.from(json["photo"]!.map((x) => Photo.fromJson(x))),
        brandName: json["brandName"],
        brandModelName: json["brandModelName"],
        tripsCount: json["tripsCount"],
        percentageRate: json["percentageRate"],
    );

    Map<String, dynamic> toJson() => {
        "carID": carId,
        "availability": availability,
         "documentExpire": documentExpire,
        "status": status,
        "photoUrl": photoUrl,
        "endDate": endDate,
        "pricePerDay": pricePerDay,
        "startDate": startDate,
        "state": state == null ? [] : List<dynamic>.from(state!.map((x) => x.toJson())),
        "city": city == null ? [] : List<dynamic>.from(city!.map((x) => x.toJson())),
        "photo": photo == null ? [] : List<dynamic>.from(photo!.map((x) => x.toJson())),
        "brandName": brandName,
        "brandModelName": brandModelName,
        "tripsCount": tripsCount,
        "percentageRate": percentageRate,
    };
}

class City {
    final dynamic cityCode;
    final dynamic cityName;

    City({
        this.cityCode,
        this.cityName,
    });

    factory City.fromRawJson(String str) => City.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory City.fromJson(Map<String, dynamic> json) => City(
        cityCode: json["cityCode"],
        cityName: json["cityName"],
    );

    Map<String, dynamic> toJson() => {
        "cityCode": cityCode,
        "cityName": cityName,
    };
}

class Photo {
    final dynamic photoCode;
    final dynamic photoUrl;

    Photo({
        this.photoCode,
        this.photoUrl,
    });

    factory Photo.fromRawJson(String str) => Photo.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        photoCode: json["photoCode"],
        photoUrl: json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "photoCode": photoCode,
        "photoUrl": photoUrl,
    };
}

class State {
    final dynamic stateCode;
    final dynamic stateName;

    State({
        this.stateCode,
        this.stateName,
    });

    factory State.fromRawJson(String str) => State.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory State.fromJson(Map<String, dynamic> json) => State(
        stateCode: json["stateCode"],
        stateName: json["stateName"],
    );

    Map<String, dynamic> toJson() => {
        "stateCode": stateCode,
        "stateName": stateName,
    };
}
