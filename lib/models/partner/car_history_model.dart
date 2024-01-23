import 'dart:convert';

class CarHistory {
    final int? statusCode;
    final String? status;
    final List<CarHistoryData>? data;

    CarHistory({
        this.statusCode,
        this.status,
        this.data,
    });

    factory CarHistory.fromRawJson(String str) => CarHistory.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CarHistory.fromJson(Map<String, dynamic> json) => CarHistory(
        statusCode: json["status_code"],
        status: json["status"],
        data: json["data"] == null ? [] : List<CarHistoryData>.from(json["data"]!.map((x) => CarHistoryData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class CarHistoryData {
    final dynamic carId;
    final dynamic availability;
    final dynamic plateNumber;
    final dynamic status;
    final dynamic vin;
    final dynamic about;
    final dynamic photoUrl;
    final dynamic advanceDays;
    final dynamic discountDays;
    final dynamic discountPrice;
    final dynamic endDate;
    final dynamic pricePerDay;
    final dynamic startDate;
    final List<Brand>? brand;
    final List<BrandModel>? brandModel;
    final List<dynamic>? modelYear;
    final List<State>? state;
    final List<City>? city;
    final List<Type>? type;
    final List<Transmission>? transmission;
    final List<Seat>? seat;
    final List<Insurance>? insurance;
    final List<Driver>? driver;
    final List<Document>? document;
    final List<Photo>? photo;
    final List<Feature>? feature;
    final dynamic tripsCount;
    final dynamic percentage;
    final dynamic feedbackCount;
    final dynamic totalEarning;

    CarHistoryData({
        this.carId,
        this.availability,
        this.plateNumber,
        this.status,
        this.vin,
        this.about,
        this.photoUrl,
        this.advanceDays,
        this.discountDays,
        this.discountPrice,
        this.endDate,
        this.pricePerDay,
        this.startDate,
        this.brand,
        this.brandModel,
        this.modelYear,
        this.state,
        this.city,
        this.type,
        this.transmission,
        this.seat,
        this.insurance,
        this.driver,
        this.document,
        this.photo,
        this.feature,
        this.tripsCount,
        this.percentage,
        this.feedbackCount,
        this.totalEarning,
    });

    factory CarHistoryData.fromRawJson(String str) => CarHistoryData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CarHistoryData.fromJson(Map<String, dynamic> json) => CarHistoryData(
        carId: json["carID"],
        availability: json["availability"],
        plateNumber: json["plateNumber"],
        status: json["status"],
        vin: json["vin"],
        about: json["about"],
        photoUrl: json["photoUrl"],
        advanceDays: json["advanceDays"],
        discountDays: json["discountDays"],
        discountPrice: json["discountPrice"],
        endDate: json["endDate"],
        pricePerDay: json["pricePerDay"],
        startDate: json["startDate"],
        brand: json["brand"] == null ? [] : List<Brand>.from(json["brand"]!.map((x) => Brand.fromJson(x))),
        brandModel: json["brandModel"] == null ? [] : List<BrandModel>.from(json["brandModel"]!.map((x) => BrandModel.fromJson(x))),
        modelYear: json["modelYear"] == null ? [] : List<dynamic>.from(json["modelYear"]!.map((x) => x)),
        state: json["state"] == null ? [] : List<State>.from(json["state"]!.map((x) => State.fromJson(x))),
        city: json["city"] == null ? [] : List<City>.from(json["city"]!.map((x) => City.fromJson(x))),
        type: json["type"] == null ? [] : List<Type>.from(json["type"]!.map((x) => Type.fromJson(x))),
        transmission: json["transmission"] == null ? [] : List<Transmission>.from(json["transmission"]!.map((x) => Transmission.fromJson(x))),
        seat: json["seat"] == null ? [] : List<Seat>.from(json["seat"]!.map((x) => Seat.fromJson(x))),
        insurance: json["insurance"] == null ? [] : List<Insurance>.from(json["insurance"]!.map((x) => Insurance.fromJson(x))),
        driver: json["driver"] == null ? [] : List<Driver>.from(json["driver"]!.map((x) => Driver.fromJson(x))),
        document: json["document"] == null ? [] : List<Document>.from(json["document"]!.map((x) => Document.fromJson(x))),
        photo: json["photo"] == null ? [] : List<Photo>.from(json["photo"]!.map((x) => Photo.fromJson(x))),
        feature: json["feature"] == null ? [] : List<Feature>.from(json["feature"]!.map((x) => Feature.fromJson(x))),
        tripsCount: json["tripsCount"],
        percentage: json["percentage"],
        feedbackCount: json["feedbackCount"],
        totalEarning: json["totalEarning"],
    );

    Map<String, dynamic> toJson() => {
        "carID": carId,
        "availability": availability,
        "plateNumber": plateNumber,
        "status": status,
        "vin": vin,
        "about": about,
        "photoUrl": photoUrl,
        "advanceDays": advanceDays,
        "discountDays": discountDays,
        "discountPrice": discountPrice,
        "endDate": endDate,
        "pricePerDay": pricePerDay,
        "startDate": startDate,
        "brand": brand == null ? [] : List<dynamic>.from(brand!.map((x) => x.toJson())),
        "brandModel": brandModel == null ? [] : List<dynamic>.from(brandModel!.map((x) => x.toJson())),
        "modelYear": modelYear == null ? [] : List<dynamic>.from(modelYear!.map((x) => x)),
        "state": state == null ? [] : List<dynamic>.from(state!.map((x) => x.toJson())),
        "city": city == null ? [] : List<dynamic>.from(city!.map((x) => x.toJson())),
        "type": type == null ? [] : List<dynamic>.from(type!.map((x) => x.toJson())),
        "transmission": transmission == null ? [] : List<dynamic>.from(transmission!.map((x) => x.toJson())),
        "seat": seat == null ? [] : List<dynamic>.from(seat!.map((x) => x.toJson())),
        "insurance": insurance == null ? [] : List<dynamic>.from(insurance!.map((x) => x.toJson())),
        "driver": driver == null ? [] : List<dynamic>.from(driver!.map((x) => x.toJson())),
        "document": document == null ? [] : List<dynamic>.from(document!.map((x) => x.toJson())),
        "photo": photo == null ? [] : List<dynamic>.from(photo!.map((x) => x.toJson())),
        "feature": feature == null ? [] : List<dynamic>.from(feature!.map((x) => x.toJson())),
        "tripsCount": tripsCount,
        "percentage": percentage,
        "feedbackCount": feedbackCount,
        "totalEarning": totalEarning,
    };
}

class Brand {
    final String? brandCode;
    final String? brandName;

    Brand({
        this.brandCode,
        this.brandName,
    });

    factory Brand.fromRawJson(String str) => Brand.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        brandCode: json["brandCode"],
        brandName: json["brandName"],
    );

    Map<String, dynamic> toJson() => {
        "brandCode": brandCode,
        "brandName": brandName,
    };
}

class BrandModel {
    final String? modelCode;
    final String? modelName;

    BrandModel({
        this.modelCode,
        this.modelName,
    });

    factory BrandModel.fromRawJson(String str) => BrandModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        modelCode: json["modelCode"],
        modelName: json["modelName"],
    );

    Map<String, dynamic> toJson() => {
        "modelCode": modelCode,
        "modelName": modelName,
    };
}

class City {
    final String? cityCode;
    final String? cityName;

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

class Document {
    final String? documentName;
    final String? documentUrl;

    Document({
        this.documentName,
        this.documentUrl,
    });

    factory Document.fromRawJson(String str) => Document.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        documentName: json["documentName"],
        documentUrl: json["documentURL"],
    );

    Map<String, dynamic> toJson() => {
        "documentName": documentName,
        "documentURL": documentUrl,
    };
}

class Driver {
    final String? driverEmail;
    final String? driverNumber;
    final String? expireDate;
    final String? fullName;
    final String? licenseNumber;
    final String? licenseUpload;

    Driver({
        this.driverEmail,
        this.driverNumber,
        this.expireDate,
        this.fullName,
        this.licenseNumber,
        this.licenseUpload,
    });

    factory Driver.fromRawJson(String str) => Driver.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        driverEmail: json["driverEmail"],
        driverNumber: json["driverNumber"],
        expireDate: json["expireDate"],
        fullName: json["fullName"],
        licenseNumber: json["licenseNumber"],
        licenseUpload: json["licenseUpload"],
    );

    Map<String, dynamic> toJson() => {
        "driverEmail": driverEmail,
        "driverNumber": driverNumber,
        "expireDate": expireDate,
        "fullName": fullName,
        "licenseNumber": licenseNumber,
        "licenseUpload": licenseUpload,
    };
}

class Feature {
    final String? featuresCode;
    final String? featuresName;

    Feature({
        this.featuresCode,
        this.featuresName,
    });

    factory Feature.fromRawJson(String str) => Feature.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        featuresCode: json["featuresCode"],
        featuresName: json["featuresName"],
    );

    Map<String, dynamic> toJson() => {
        "featuresCode": featuresCode,
        "featuresName": featuresName,
    };
}

class Insurance {
    final String? insuranceCode;
    final String? insuranceName;

    Insurance({
        this.insuranceCode,
        this.insuranceName,
    });

    factory Insurance.fromRawJson(String str) => Insurance.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
        insuranceCode: json["insuranceCode"],
        insuranceName: json["insuranceName"],
    );

    Map<String, dynamic> toJson() => {
        "insuranceCode": insuranceCode,
        "insuranceName": insuranceName,
    };
}

class Photo {
    final String? photoCode;
    final String? photoUrl;

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

class Seat {
    final String? seatCode;
    final String? seatName;

    Seat({
        this.seatCode,
        this.seatName,
    });

    factory Seat.fromRawJson(String str) => Seat.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Seat.fromJson(Map<String, dynamic> json) => Seat(
        seatCode: json["seatCode"],
        seatName: json["seatName"],
    );

    Map<String, dynamic> toJson() => {
        "seatCode": seatCode,
        "seatName": seatName,
    };
}

class State {
    final String? stateCode;
    final String? stateName;

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

class Transmission {
    final String? transmissionCode;
    final String? transmissionName;

    Transmission({
        this.transmissionCode,
        this.transmissionName,
    });

    factory Transmission.fromRawJson(String str) => Transmission.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Transmission.fromJson(Map<String, dynamic> json) => Transmission(
        transmissionCode: json["transmissionCode"],
        transmissionName: json["transmissionName"],
    );

    Map<String, dynamic> toJson() => {
        "transmissionCode": transmissionCode,
        "transmissionName": transmissionName,
    };
}

class Type {
    final String? typeCode;
    final String? typeName;

    Type({
        this.typeCode,
        this.typeName,
    });

    factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Type.fromJson(Map<String, dynamic> json) => Type(
        typeCode: json["typeCode"],
        typeName: json["typeName"],
    );

    Map<String, dynamic> toJson() => {
        "typeCode": typeCode,
        "typeName": typeName,
    };
}
