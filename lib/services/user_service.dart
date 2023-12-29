import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getx;
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/services/api_service.dart';
import 'package:gti_rides/services/logger.dart';

UserService get userService => getx.Get.find();

class UserService {
  Logger logger = Logger('UserService');
  // Rx<Agent> agentModel = Agent().obs;
  getx.Rx<UserModel> user = UserModel().obs;
  getx.Rx<ListResponseModel> userKyc = ListResponseModel().obs;
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static final UserService _cache = UserService._internal();

  factory UserService() {
    return _cache;
  }

  UserService._internal() {
    init();
  }

  void init() {
    logger.log('Initializing Uer service');
  }

  // bool setCurrentAgentModel(agent) {
  //   agentModel.value = Agent.fromJson(agent);
  //   return true;
  // }

  bool setCurrentUser(userJson) {
    user.value = UserModel.fromJson(userJson);
    return true;
  }

  bool setUserKyc(userKycJson) {
    userKyc.value = ListResponseModel.fromJson(userKycJson);
    return true;
  }

  UserModel? getCurrentUser() {
    return user.value;
  }

  Future<ApiResponseModel> updateProfile({required FormData payload}) async {
    try {
      final result = await apiService.putRequestFile(
        endpoint: '/user/profile/editProfile',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log(" Error: $err");
      rethrow;
    }
  }

  Future<ApiResponseModel> updateKyc({required FormData payload}) async {
    try {
      final result = await apiService.putRequestFile(
        endpoint: '/user/profile/addKYC',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log(" Error: $err");
      rethrow;
    }
  }

  Future<ListResponseModel> getKycProfile() async {
    try {
      final result = await apiService.getRequest(
        '/user/profile/getKYC',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> changePassword({required Map payload}) async {
    try {
      final result = await apiService.putRequest(
        endpoint: '/user/profile/changePassword',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("Login Error: $err");
      rethrow;
    }
  }

// Persisting User Data in local storage
  Future<void> saveUserData(UserModel user) async {
    logger.log('Saving user data');
    String userJson = json.encode(user.toJson());
    await _secureStorage.write(key: 'user_data', value: userJson);
  }

  Future<UserModel?> getUserData() async {
    logger.log('Getting user data');
    String? userJson = await _secureStorage.read(key: 'user_data');
    if (userJson != null) {
      Map<String, dynamic> userModelMap = json.decode(userJson);
      return UserModel.fromJson(userModelMap);
    }
    return null;
  }

  Future<void> deleteUserData() async {
    logger.log('Deleting user data');
    await _secureStorage.delete(key: 'user_data');
  }
}
