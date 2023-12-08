import 'dart:convert';

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
