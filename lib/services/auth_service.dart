import 'dart:convert';
import 'package:get/get.dart';
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
      var jsonString;
      final result = await apiService.postRequest(
        endpoint: '/user/auth/register',
        data: payload,
      );

      // Convert the Map result into a JSON string
      // if (result != null) {
      //   jsonString = jsonEncode(result);
      // }

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
        endpoint: 'user/auth/resendOTP',
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

  Future<ApiResponseModel> resetPassword({required Map payload}) async {
    try {
      final result = await apiService.postRequest(
        endpoint: '/auth/reset-password',
        data: payload,
      );
      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> getProfile() async {
    // try {
    //   final result = await apiService.postRequest(
    //     endpoint: '/auth/verify-otp-email',
    //     data: payload,
    //   );
    //   return ApiResponseModel.fromJson(result);
    // } catch (err) {
    //   rethrow;
    // }
    throw UnimplementedError();
  }

  Future<ApiResponseModel> getNewAccessToken(
      {required String refreshToken}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/auth/refresh', token: refreshToken);
      return ApiResponseModel.fromJson(result);
    } catch (err) {
      rethrow;
    }
  }
}
