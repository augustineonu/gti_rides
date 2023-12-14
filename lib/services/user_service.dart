import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/services/api_service.dart';
import 'package:gti_rides/services/logger.dart';

UserService get userService => getX.Get.find();

class UserService {
  Logger logger = Logger('UserService');
  // Rx<Agent> agentModel = Agent().obs;
  getX.Rx<UserModel> user = UserModel().obs;

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

  UserModel? getCurrentUser() {
    return user.value;
  }

  
  Future<ApiResponseModel> updateProfile({required FormData  payload}) async {
    try {
      final result = await apiService.putRequestFile(
        endpoint: '/user/profile/editProfile',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("Login Error: $err");
      rethrow;
    }
  }


  // Agent? getCurrentAgentModel() {
  //   return agentModel.value;
  // }

}