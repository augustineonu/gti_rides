import 'dart:convert';

import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/services/api_service.dart';
import 'package:gti_rides/services/logger.dart';

RenterService get renterService => Get.find();

class RenterService {
  Logger logger = Logger('RenterService');
  // Rx<Agent> agentModel = Agent().obs;
  Rx<UserModel> user = UserModel().obs;

  static final RenterService _cache = RenterService._internal();

  factory RenterService() {
    return _cache;
  }

  RenterService._internal() {
    init();
  }

  void init() {
    logger.log('Initializing Renter service');
  }

  Future<ApiResponseModel> switchProfile(
      {required Map<String, dynamic> payload}) async {
    try {
      final result = await apiService.putRequest(
        endpoint: '/user/profile/updateUserType',
        data: payload,
      );
      logger.log("Switch profile response: ${result}");

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("Switch profile Error: $err");
      rethrow;
    }
  }

  bool setCurrentUser(userJson) {
    user.value = UserModel.fromJson(userJson);
    return true;
  }

  UserModel? getCurrentUser() {
    return user.value;
  }

  // Agent? getCurrentAgentModel() {
  //   return agentModel.value;
  // }

  Future<ListResponseModel> getRecentCars() async {
    try {
      final result = await apiService.getRequest(
        '/user/renter/car/getRecentCars?skip=0&limit=10',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getOneCar({required String carId}) async {
    try {
      final result = await apiService.getRequest(
        '/user/renter/car/getOneCar?carID=$carId',
      );
      // logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getReview({required String carId,
  String? type, String? filter}) async {
    try {
      final result = await apiService.getRequest(
        // /user/partner/getReview?carID=a9UExyBrC4&skip=0&limit=10
        '/user/${type ?? 'renter'}/getReview?carID=$carId&skip=0&limit=1000${filter ?? ''}',
      );
      // {{BaseLocal}}/user/renter/getReview?carID=a9UExyBrC4&skip=0&limit=10
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> addFavoriteCar({required String carId}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/renter/car/addFavoriteCar', data: {"carID": carId});
      // logger.log("result $result");

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> deleteFavoriteCar({required String carId}) async {
    try {
      final result = await apiService.deleteRequest(
          endpoint: '/user/renter/car/deleteFavoriteCar',
          data: {"carID": carId});
      // logger.log("result $result");

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getFavoriteCars() async {
    try {
      final result = await apiService.getRequest(
        '/user/renter/car/getFavoriteCars?skip=0&limit=100000',
      );
      // logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> searchCars(
      {required String stateCode,
      String? cityCode,
      required String startDate,
      required String endDate}) async {
    try {
      final result = await apiService.getRequest(
        '/user/renter/car/getCars?stateCode=$stateCode&cityCode&skip=0&limit=1000000&startDate=$startDate&endDate=$endDate',
      );
      // logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getTripAmountData() async {
    try {
      final result = await apiService.getRequest(
        '/user/renter/trip/getTripsData',
      );
      // logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getCarTrip({
    required String carID,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final result = await apiService.getRequest(
        '/user/renter/trip/checkCarTrips?carID=$carID&startDate=$startDate&endDate=$endDate',
      );
      // logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> addRecentCar({required String carId}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/renter/car/addRecentCar', data: {"carID": carId});
      // logger.log("result $result");

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> addReview(
      {required String carId, required Map data}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/renter/addReview?carID=$carId', data: data);
      // logger.log("result $result");

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> updateTripStatus({
    required String type,
    required String tripID,
  }) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/renter/trip/updateTripStatus',
          data: {"type": type, "tripID": tripID});
      // logger.log("result $result");

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getAllTrips({
    String? status,
    required String? param,
  }) async {
    try {
      final result = await apiService.getRequest(
        '/user/$param/trip/getAllTrips?status=&skip=0&limit=10000',
      );
      // logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }
}
