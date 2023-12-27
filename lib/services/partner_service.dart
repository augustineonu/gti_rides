import 'dart:convert';

import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/services/api_service.dart';
import 'package:gti_rides/services/logger.dart';

PartnerService get partnerService => Get.find();

class PartnerService {
  Logger logger = Logger('OwnerService');
  // Rx<Agent> agentModel = Agent().obs;
  Rx<UserModel> user = UserModel().obs;

  static final PartnerService _cache = PartnerService._internal();

  factory PartnerService() {
    return _cache;
  }

  PartnerService._internal() {
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

  Future<ListResponseModel> getBrand() async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getBrand',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getVehicleYear({required String brandCode}) async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getVehicleYear?brandCode=$brandCode',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getStates() async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getStates',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getCity({required String cityCode}) async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getCity?stateCode=$cityCode',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> addCar({required Map data}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/partner/car/addCar', data: data);
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

    Future<ListResponseModel> getTransmission() async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getTransmission',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }
    Future<ListResponseModel> getFeatures() async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getFeatures',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }
    Future<ListResponseModel> getVehicleType() async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getVehicleType',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }
}
