import 'dart:convert';
import 'package:get/get.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/services/api_service.dart';
import '../models/api_response_model.dart';
import 'logger.dart';

AuthService authService = Get.find();

class AuthService {
  Logger logger = Logger('AuthService');

  Future<Map<String, dynamic>> signUp1({required Map payload}) async {
    try {
      var jsonString;
      final Map<String, dynamic> result = await apiService.postRequest(
        endpoint: '/user/auth/register',
        data: payload,
      );

      // Convert the Map result into a JSON string
      // if (result != null) {
      //   jsonString = jsonEncode(result);
      // }
      //  jsonString = jsonEncode(result);

      return result;
    } catch (err) {
      logger.log("SignUp Error: $err");
      rethrow;
    }
  }

  Future<ApiResponseModel> signUp({required Map payload}) async {
    try {
      final result = await apiService.postRequest(
        endpoint: '/user/auth/register',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("SignUp Error: $err");
      rethrow;
    }
  }

  Future<ApiResponseModel> login({required Map payload}) async {
    try {
      final result = await apiService.postRequest(
        endpoint: '/user/auth/login',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("Login Error: $err");
      rethrow;
    }
  }

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

  Future<ApiResponseModel> logOut({required String token}) async {
    try {
      final result = await apiService.postRequest(
        endpoint: '/auth/logout',
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("Logout Error: $err");
      rethrow;
    }
  }

  Future<ApiResponseModel> resendOTP({required Map payload}) async {
    try {
      final result = await apiService.postRequest(
        endpoint: '/user/auth/resendOTP',
        data: payload,
      );
      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("Login Error: $err");
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
      final result = await apiService.postRequest(
        endpoint: '/user/auth/resetPassword',
        data: payload,
      );
      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> resetPassword(
      {required Map payload, required String token}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/auth/addNewPassword', data: payload, token: token);
      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> socialSignUp({required Map payload}) async {
    try {
      final result = await apiService.postRequest(
        endpoint: '/user/auth/socialProfile',
        data: payload,
      );
      return ApiResponseModel.fromJson(result);
    } catch (err) {
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

  Future<ApiResponseModel> getNewAccessToken(
      {required String accessToken}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/auth/refreshToken', token: accessToken);
      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }
}
