import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'logger.dart';

ApiService get apiService => getx.Get.find();

class ApiService {
  Logger logger = Logger('ApiService');
  final String baseURL = AppStrings.baseURL;
  late final Dio _dio;

  static final ApiService _cache = ApiService._internal();

  factory ApiService() {
    return _cache;
  }

  ApiService._internal() {
    init();
  }

  Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseURL,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Options get options {
    return Options(
      headers: {
        // 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<dynamic> postRequest({
    required String endpoint,
    Map? data,
    String? token,
  }) async {
    try {
      logger.log("POST REQUEST DATA:: $data");
      late Response response;
      response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${token ?? tokenService.accessToken.value}',
          },
        ),
      );
      logger.log("POST REQUEST RESPONSE:: $response");
      final ApiResponseModel apiResponse =
          ApiResponseModel.fromJson(response.data);
      if (!endpoint.contains('auth')) {
        if (apiResponse.status != 'success'.toLowerCase() ||
            apiResponse.status_code == 401) {
          bool newAccessTokenResult = await tokenService.getNewAccessToken();
          logger.log("HELLLL");
          if (!newAccessTokenResult) {
            logger.log("HELLLL22");
            logger.log('Going to welcome screen');
            // routeService.offAllNamed(AppLinks.welcomeBack);
            return;
          }
          response = await _dio.post(
            endpoint,
            data: data,
            options: Options(
              headers: {
                'Authorization':
                    'Bearer ${token ?? tokenService.accessToken.value}',
              },
            ),
          );
        } else if (apiResponse.status_code == 403) {
          logger.log('Going to login screen');
          logger.log("HELLLL33");
          _logOut();
          return;
        }
      }
      logger.log('response${response.data}');
      return response.data;
    } on DioException catch (e) {
      logger.log("POST REQUEST ERROR ($endpoint) :: ${e.response?.data}");
      if (e.response?.data != null) {
        return e.response?.data;
      }
      throw "An error occurred";
    } on SocketException {
      throw "seems you are offline";
    } catch (error) {
      throw error.toString();
    }
  }

  Future<dynamic> putRequest({
    required String endpoint,
    required Map data,
  }) async {
    try {
      late Response response;
      logger.log("PATCH REQUEST DATA:: $data");
      response = await _dio.put(
        endpoint,
        data: data,
        options: Options(
          headers: {
            // 'Authorization': 'Bearer ${tokenService.accessToken.value}',
          },
        ),
      );
      logger.log("PATCH REQUEST RESPONSE:: $response");
      final ApiResponseModel apiResponse =
          ApiResponseModel.fromJson(response.data);
      // if (!apiResponse.status || apiResponse.statusCode == 401) {
      //   bool newAccessTokenResult = await tokenService.getNewAccessToken();
      //   if (!newAccessTokenResult) {
      //     logger.log('Going to welcome screen');
      //     routeService.offAllNamed(AppLinks.welcomeBack);
      //     return;
      //   }
      //   response = await _dio.put(
      //     endpoint,
      //     data: data,
      //     options: Options(
      //       headers: {
      //         // 'Authorization': 'Bearer ${tokenService.accessToken.value}',
      //       },
      //     ),
      //   );
      // }
      return response.data;
    } on DioException catch (e) {
      logger.log("POST REQUEST ERROR ($endpoint) :: ${e.response?.data}");
      if (e.response?.data != null) {
        return e.response?.data;
      }
      throw "An error occurred";
    } on SocketException {
      throw "seems you are offline";
    } catch (error) {
      throw error.toString();
    }
  }

  Future<dynamic> putRequestFile({
    required String endpoint,
    required FormData data,
  }) async {
    try {
      logger.log("PATCH REQUEST DATA:: $data");
      late Response response;
      response = await _dio.put(
        endpoint,
        data: data,
        options: Options(
          headers: {
            // 'Authorization': 'Bearer ${tokenService.accessToken.value}',
            'Content-Type': 'image/png'
          },
        ),
      );
      logger.log("PATCH REQUEST RESPONSE:: $response");
      final ApiResponseModel apiResponse =
          ApiResponseModel.fromJson(response.data);
      // if (!apiResponse.status || apiResponse.statusCode == 401) {
      //   bool newAccessTokenResult = await tokenService.getNewAccessToken();
      //   if (!newAccessTokenResult) {
      //     logger.log('Going to welcome screen');
      //     routeService.offAllNamed(AppLinks.welcomeBack);
      //     return;
      //   }
      //   response = await _dio.put(
      //     endpoint,
      //     data: data,
      //     options: Options(
      //       headers: {
      //         'Authorization': 'Bearer ${tokenService.accessToken.value}',
      //         'Content-Type': 'image/png'
      //       },
      //     ),
      //   );
      // }
      return response.data;
    } on DioException catch (e) {
      logger.log("POST REQUEST ERROR ($endpoint) :: ${e.response?.data}");
      if (e.response?.data != null) {
        return e.response?.data;
      }
      throw "An error occurred";
    } on SocketException {
      throw "seems you are offline";
    } catch (error) {
      throw error.toString();
    }
  }

  Future<dynamic> getRequest(
    String endpoint,
  ) async {
    try {
      late Response response;
      late ApiResponseModel apiResponse;
      response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            // 'Authorization': 'Bearer ${tokenService.accessToken.value}',
          },
        ),
      );
      logger.log("GET REQUEST RESPONSE ($endpoint) :: $response");
      apiResponse = ApiResponseModel.fromJson(response.data);
      // if (!apiResponse.status || apiResponse.statusCode == 401) {
      //   bool newAccessTokenResult = await tokenService.getNewAccessToken();
      //   if (!newAccessTokenResult) {
      //     logger.log('Going to welcome screen');
      //     // routeService.offAllNamed(AppLinks.welcomeBack);
      //     return;
      //   }
      //   response = await _dio.get(
      //     endpoint,
      //     options: Options(
      //       headers: {
      //         // 'Authorization': 'Bearer ${tokenService.accessToken.value}',
      //       },
      //     ),
      //   );
      //   apiResponse = ApiResponseModel.fromJson(response.data);
      // }
      return apiResponse;
    } on DioException catch (e) {
      logger.log("POST REQUEST ERROR ($endpoint) :: ${e.response?.data}");
      if (e.response?.data != null) {
        return e.response?.data;
      }
      throw "An error occurred";
    } on SocketException {
      throw "seems you are offline";
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> _logOut() async {
    try {
      // final result = await authService.logOut(token: tokenService.accessToken.value);
      // if (!result.status || result.statusCode == 401) {
      //   bool newAccessTokenResult = await tokenService.getNewAccessToken();
      //   if (!newAccessTokenResult) {
      //     logger.log('Going to welcome screen');
      //     routeService.offAllNamed(AppLinks.welcomeBack);
      //   }
      //   await authService.logOut(token: token);
      //   routeService.offAllNamed(AppLinks.login);
      // }

      //////
      ///
      // await biometricService.clearAll();
      // await authService.logOut(token: tokenService.accessToken.value);
      // await biometricService.clearAll();
      // routeService.offAllNamed(AppLinks.login);
    } catch (err) {
      logger.log("error: $err");
      rethrow;
    } finally {}
  }
}
