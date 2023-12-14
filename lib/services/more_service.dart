import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/services/api_service.dart';
import '../models/api_response_model.dart';
import 'logger.dart';

MoreService moreService = getX.Get.find();

class MoreService {
  Logger logger = Logger('MoreService');




  Future<ApiResponseModel> resendOtp({required Map payload}) async {
    try {
      final result = await apiService.postRequest(
        endpoint: '/user/auth/resendOTP',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("Resend OTP Error: $err");
      rethrow;
    }
  }

  
  Future<ApiResponseModel> verifyOtp({required Map payload}) async {
    try {
      final result = await apiService.postRequest(
        endpoint: '/user/auth/verifyOTP',
        data: payload,
      );
      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> requestResetPassword({required Map payload}) async {
    try {
      final result = await apiService.putRequest(
        endpoint: '/user/profile/changePassword',
        data: payload,
      );
      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
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

  Future<ListResponseModel> getProfile() async {
    try {
      final result = await apiService.getRequest(
        '/user/profile/getMyProfile',
      );
      logger.log("result $result");
      
       final decodedResult = json.decode(result);

    return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

}
