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
        connectTimeout: Duration(seconds: 6000),
        receiveTimeout: Duration(seconds: 6000),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add the access token to the request header
          
          options.headers['Authorization'] =
              'Bearer ${tokenService.accessToken.value}';
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 400) {
            // If a 401 response is received, refresh the access token
            // String newAccessToken = await refreshToken();
            bool newAccessTokenResult = await tokenService.getNewAccessToken();
            if (!newAccessTokenResult) {
              logger.log('Going to Login screen');
              routeService.offAllNamed(AppLinks.login);
              return;
            }

            // Update the request header with the new access token
            e.requestOptions.headers['Authorization'] =
                'Bearer ${tokenService.accessToken.value}';
                
                _dio.options.headers['Authorization'] =
                'Bearer ${tokenService.accessToken.value}';

            // Repeat the request with the updated header
            return handler.resolve(await _dio.fetch(e.requestOptions));
          } else if(e.response?.statusCode == 403) {
            logger.log("status code == 403");
          }
          return handler.next(e);
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
      logger.log("POST REQUEST DATA:: $baseURL  $endpoint $data");
      late Response response;
      response = await _dio.post(
        endpoint,
        data: data,
        // options: Options(
        //   headers: {
        //     'Authorization':
        //         'Bearer ${token ?? tokenService.accessToken.value}',
        //   },
        // ),
      );
      logger.log("POST REQUEST RESPONSE:: $response");
      final ApiResponseModel apiResponse =
          ApiResponseModel.fromJson(response.data);
      if (!endpoint.contains('auth')) {
        if (apiResponse.status_code == 400) {
          // if refresh token returns invalid token, log the user out
          bool newAccessTokenResult = await tokenService.getNewAccessToken();
          logger.log("HELLLL");
          if (!newAccessTokenResult) {
            logger.log("HELLLL22");
            logger.log('Going to LOgin screen');
            routeService.offAllNamed(AppLinks.login);
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

      // Function to make the actual request
      Future<void> makeRequest() async {
        response = await _dio.put(
          endpoint,
          data: data,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${tokenService.accessToken.value}',
            },
          ),
        );
      }

      await makeRequest();

      logger.log("PATCH REQUEST RESPONSE:: $response");

      final ApiResponseModel apiResponse =
          ApiResponseModel.fromJson(response.data);

      if (apiResponse.status_code == 400) {
        // Attempt to get a new access token
        bool newAccessTokenResult = await tokenService.getNewAccessToken();

        // Log the new token value
        logger.log("New access token: ${tokenService.accessToken.value}");

        if (!newAccessTokenResult) {
          logger.log('Going to Login screen');
          routeService.offAllNamed(AppLinks.login);
          return;
        }

        // Retry the request with the new access token
        await makeRequest();
      }

      return response.data;
    } on DioException catch (e) {
      logger.log("PUT REQUEST ERROR ($endpoint) :: ${e.response?.data}");
      if (e.response?.data != null) {
        return e.response?.data;
      }
      // Throw a custom exception or return an error object
      throw "An error occurred";
    } on SocketException {
      throw "Seems you are offline";
    } catch (error) {
      logger.log("Error: $error");
      throw error.toString();
    }
  }

  // Future<dynamic> putRequestFile({
  //   required String endpoint,
  //   required FormData data,
  // }) async {
  //   try {
  //     logger.log("PATCH REQUEST DATA:: ${data.fields.toString()}");
  //     // late Response response;
  //     Response response = await _dio.put(
  //       endpoint,
  //       data: data,
  //       options: Options(
  //         // receiveDataWhenStatusError: false,
  //         headers: {
  //           'Authorization': 'Bearer ${tokenService.accessToken.value}',
  //         },
  //       ),
  //     );
  //     logger.log("PATCH REQUEST  ($endpoint) :: ${response.data}");

  //     // logger.log("PATCH REQUEST RESPONSE:: $response");
  //     final ApiResponseModel apiResponse =
  //         ApiResponseModel.fromJson(response.data);

  //     // Check if the response status code is 400 and handle it globally
  //     if (apiResponse.status_code == 400) {
  //       bool newAccessTokenResult = await tokenService.getNewAccessToken();
  //       if (!newAccessTokenResult) {
  //         logger.log('Going to Login screen');
  //         routeService.offAllNamed(AppLinks.login);
  //         return;
  //       }

  //       // Retry the request with the new access token
  //       response = await _dio.put(
  //         endpoint,
  //         data: data,
  //         options: Options(
  //           headers: {
  //             'Authorization': 'Bearer ${tokenService.accessToken.value}',
  //             'Content-Type': 'image/png',
  //           },
  //         ),
  //       );
  //     }

  //     // Propagate the response to the caller
  //     return apiResponse;
  //   } on DioException catch (e) {
  //     logger.log("PATCH REQUEST ERROR ($endpoint) :: ${e.response?.data}");

  //     final ApiResponseModel apiResponse =
  //         ApiResponseModel.fromJson(e.response!.data);
  //     // return apiResponse;
  //     // Propagate the error to the caller
  //     // if (e.response?.data != null) {
  //     //   return e.response?.data;
  //     // }
  //     // throw "An error occurred";
  //   } on SocketException {
  //     throw "seems you are offline";
  //   } catch (error) {
  //     throw error.toString();
  //   }
  // }

    Future<dynamic> postRequestFile({
    required String endpoint,
    required FormData data,
  }) async {
    try {
      logger.log("POST REQUEST DATA:: ${data.fields.toString()}");
      logger.log("POST REQUEST DATA:: ${data.files.toString()}");
      late Response response;
      response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${tokenService.accessToken.value}',
           'Content-Type': 'multipart/form-data'
          },
        ),
      );
      logger.log("POST REQUEST RESPONSE:: $response");
      final ApiResponseModel apiResponse =
          ApiResponseModel.fromJson(response.data);
      if (apiResponse.status != "success" || apiResponse.status_code == 401) {
        bool newAccessTokenResult = await tokenService.getNewAccessToken();
        if (!newAccessTokenResult) {
          logger.log('Going to welcome screen');
          routeService.offAllNamed(AppLinks.login);
          return;
        }
        response = await _dio.post(
          endpoint,
          data: data,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${tokenService.accessToken.value}',
              'Content-Type': 'multipart/form-data'

            },
          ),
        );
      }
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
      logger.log("PATCH REQUEST DATA:: ${data.fields.toString()}");
      logger.log("PATCH REQUEST DATA:: ${data.files.toString()}");
      late Response response;
      response = await _dio.put(
        endpoint,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${tokenService.accessToken.value}',

            'Content-Type': 'multipart/form-data'
            
          },
        ),
      );
      logger.log("PATCH REQUEST RESPONSE:: $response");
      final ApiResponseModel apiResponse =
          ApiResponseModel.fromJson(response.data);
      if (apiResponse.status != "success" || apiResponse.status_code == 401) {
        bool newAccessTokenResult = await tokenService.getNewAccessToken();
        if (!newAccessTokenResult) {
          logger.log('Going to welcome screen');
          routeService.offAllNamed(AppLinks.login);
          return;
        }
        response = await _dio.put(
          endpoint,
          data: data,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${tokenService.accessToken.value}',
              'Content-Type': 'multipart/form-data'
            },
          ),
        );
      }
      return response.data;
    } on DioException catch (e) {
      logger.log("PATCH REQUEST ERROR ($endpoint) :: ${e.response?.data}");
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
          responseType: ResponseType.plain,
          // headers: {
          //   'Authorization': 'Bearer ${tokenService.accessToken.value}',
          // },
        ),
      );
      logger.log("GET REQUEST RESPONSE ($endpoint) :: ${response.data}");
      apiResponse = ApiResponseModel.fromRawJson(response.data.toString());
      // apiResponse = ApiResponseModel.fromJson(response.data);
      logger.log("msg: GET REQUEST");
      if (apiResponse.status_code == 400) {
        bool newAccessTokenResult = await tokenService.getNewAccessToken();
        if (!newAccessTokenResult) {
          logger.log('Going to Login screen');
          routeService.offAllNamed(AppLinks.login);
          return;
        }
        response = await _dio.get(
          endpoint,
          options: Options(
            responseType: ResponseType.plain,
            // headers: {
            //   'Authorization': 'Bearer ${tokenService.accessToken.value}',
            // },
          ),
        );
        // apiResponse = ApiResponseModel.fromJson(response.data);
        apiResponse = ApiResponseModel.fromRawJson(response.data);
      }
      return response.data;
    } on DioException catch (e) {
      logger.log("GET REQUEST ERROR ($endpoint) :: ${e.response?.data}");
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


    Future<dynamic> deleteRequest({
    required String endpoint,
    // Map? data,
    String? token,
  }) async {
    try {
      logger.log("DELETE REQUEST DATA:: $baseURL  $endpoint");
      late Response response;
      response = await _dio.delete(
        endpoint,
        // data: data,
        // options: Options(
        //   headers: {
        //     'Authorization':
        //         'Bearer ${token ?? tokenService.accessToken.value}',
        //   },
        // ),
      );
      logger.log("DELETE REQUEST RESPONSE:: $response");
      final ApiResponseModel apiResponse =
          ApiResponseModel.fromJson(response.data);
      if (!endpoint.contains('auth')) {
        if (apiResponse.status_code == 400) {
          // if refresh token returns invalid token, log the user out
          bool newAccessTokenResult = await tokenService.getNewAccessToken();
          logger.log("HELLLL");
          if (!newAccessTokenResult) {
            logger.log("HELLLL22");
            logger.log('Going to LOgin screen');
            routeService.offAllNamed(AppLinks.login);
            return;
          }
          response = await _dio.delete(
            endpoint,
            // data: data,
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
      logger.log("DELETE REQUEST ERROR ($endpoint) :: ${e.response?.data}");
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
