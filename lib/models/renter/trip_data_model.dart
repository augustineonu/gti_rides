import 'dart:convert';

class TripData {
    final String? carID;
    final String? tripStartDate;
    final String? tripEndDate;
    final String? tripsDays;
    final String? tripType;
    final String? interState;
    final String? interStateAddress;
    final String? escort;
    final String? escortValue;
    final String? pickUpType;
    final String? pickUpAddress;
    final String? dropOffType;
    final String? dropOffAddress;
    final String? routeStart;
    final String? routeEnd;

    TripData({
        this.carID,
        this.tripStartDate,
        this.tripEndDate,
        this.tripsDays,
        this.tripType,
        this.interState,
        this.interStateAddress,
        this.escort,
        this.escortValue,
        this.pickUpType,
        this.pickUpAddress,
        this.dropOffType,
        this.dropOffAddress,
        this.routeStart,
        this.routeEnd,
    });

    TripData copyWith({
        String? carID,
        String? tripStartDate,
        String? tripEndDate,
        String? tripsDays,
        String? tripType,
        String? interState,
        String? interStateAddress,
        String? escort,
        String? escortValue,
        String? pickUpType,
        String? pickUpAddress,
        String? dropOffType,
        String? dropOffAddress,
        String? routeStart,
        String? routeEnd,
    }) => 
        TripData(
            carID: carID ?? this.carID,
            tripStartDate: tripStartDate ?? this.tripStartDate,
            tripEndDate: tripEndDate ?? this.tripEndDate,
            tripsDays: tripsDays ?? this.tripsDays,
            tripType: tripType ?? this.tripType,
            interState: interState ?? this.interState,
            interStateAddress: interStateAddress ?? this.interStateAddress,
            escort: escort ?? this.escort,
            escortValue: escortValue ?? this.escortValue,
            pickUpType: pickUpType ?? this.pickUpType,
            pickUpAddress: pickUpAddress ?? this.pickUpAddress,
            dropOffType: dropOffType ?? this.dropOffType,
            dropOffAddress: dropOffAddress ?? this.dropOffAddress,
            routeStart: routeStart ?? this.routeStart,
            routeEnd: routeEnd ?? this.routeEnd,
        );

    factory TripData.fromRawJson(String str) => TripData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TripData.fromJson(Map<String, dynamic> json) => TripData(
        carID: json["carID"],
        tripStartDate: json["tripStartDate"],
        tripEndDate: json["tripEndDate"],
        tripsDays: json["tripsDays"],
        tripType: json["tripType"],
        interState: json["interState"],
        interStateAddress: json["interStateAddress"],
        escort: json["escort"],
        escortValue: json["escortValue"],
        pickUpType: json["pickUpType"],
        pickUpAddress: json["pickUpAddress"],
        dropOffType: json["dropOffType"],
        dropOffAddress: json["dropOffAddress"],
        routeStart: json["routeStart"],
        routeEnd: json["routeEnd"],
    );

    Map<String, dynamic> toJson() => {
        "carID": carID,
        "tripStartDate": tripStartDate,
        "tripEndDate": tripEndDate,
        "tripsDays": tripsDays,
        "tripType": tripType,
        "interState": interState,
        "interStateAddress": interStateAddress,
        "escort": escort,
        "escortValue": escortValue,
        "pickUpType": pickUpType,
        "pickUpAddress": pickUpAddress,
        "dropOffType": dropOffType,
        "dropOffAddress": dropOffAddress,
        "routeStart": routeStart,
        "routeEnd": routeEnd,
    };
}
