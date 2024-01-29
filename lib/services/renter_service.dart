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
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

}
