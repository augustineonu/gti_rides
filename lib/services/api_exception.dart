import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'logger.dart';

ApiExceptionService get apiExceptionService => getx.Get.find();

class ApiExceptionService {
  Logger logger = Logger('ApiExceptionService');
  final String baseURL = AppStrings.baseURL;
  late final Dio _dio;

  static final ApiExceptionService _cache = ApiExceptionService._internal();

  factory ApiExceptionService() {
    return _cache;
  }

  ApiExceptionService._internal() {
    init();
  }

  Future<void> init() async {}

  String getException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.badResponse:
        return "Bad response, check URL parameters";
      case DioExceptionType.connectionError:
        return "Connection error, check network connectivity!";
      case DioExceptionType.connectionTimeout:
        return "Connection timeout, check network connectivity!";
      case DioExceptionType.cancel:
        return "Request canceled, check URL parameters";
      case DioExceptionType.receiveTimeout:
        return "Received timeout, Network connectivity or URL parameters are invalid!";
        
      default:
        return "Unknown error, check connectivity";
    }
  }
}
