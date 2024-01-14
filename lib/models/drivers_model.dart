import 'dart:convert';

class Driver {
    final String? driverId;
    final String? driverEmail;
    final String? driverNumber;
    final String? fullName;
    final String? userId;

    Driver({
        this.driverId,
        this.driverEmail,
        this.driverNumber,
        this.fullName,
        this.userId,
    });

    Driver copyWith({
        String? driverId,
        String? driverEmail,
        String? driverNumber,
        String? fullName,
        String? userId,
    }) => 
        Driver(
            driverId: driverId ?? this.driverId,
            driverEmail: driverEmail ?? this.driverEmail,
            driverNumber: driverNumber ?? this.driverNumber,
            fullName: fullName ?? this.fullName,
            userId: userId ?? this.userId,
        );

    factory Driver.fromRawJson(String str) => Driver.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        driverId: json["driverID"],
        driverEmail: json["driverEmail"],
        driverNumber: json["driverNumber"],
        fullName: json["fullName"],
        userId: json["userID"],
    );

    Map<String, dynamic> toJson() => {
        "driverID": driverId,
        "driverEmail": driverEmail,
        "driverNumber": driverNumber,
        "fullName": fullName,
        "userID": userId,
    };
}
