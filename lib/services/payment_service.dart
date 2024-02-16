import 'dart:convert';

import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/services/api_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:dio/dio.dart' as dio;

PaymentService get paymentService => Get.find();

class PaymentService extends GetxController {
  Logger logger = Logger('PaymentService');
  Rx<UserModel> user = UserModel().obs;
  RxList<Driver>? drivers = <Driver>[].obs;

  static final PaymentService _cache = PaymentService._internal();

  factory PaymentService() {
    return _cache;
  }

  PaymentService._internal() {
    init();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    logger.log("onInit called");
  }

  void init() async {
    logger.log('Initializing Payment service');
    // await getDrivers1();
  }

  Future<ListResponseModel> getBanks() async {
    try {
      final result = await apiService.getRequest(
        '/user/partner/payment/getBankList',
      );
      // logger.log("bank list $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getBankAccount() async {
    try {
      final result = await apiService.getRequest(
        '/user/partner/payment/getBankAccount',
      );
      logger.log("bank account $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> resolveAccount({
    required String accountNumber,
    required String accountCode,
  }) async {
    try {
      final result = await apiService.getRequest(
        '/user/partner/payment/resolveAccount?accountNumber=$accountNumber&accountCode=$accountCode',
      );
      // logger.log("bank list $result");

      final decodedResult = json.decode(result);

      return ApiResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> addBanAccount(
      {required Map<dynamic, dynamic>? data}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/partner/payment/addBankAccount', data: data);

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log(" Error: $err");
      rethrow;
    }
  }

  Future<ApiResponseModel> addTrip(
      {required Map<dynamic, dynamic>? data}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/renter/trip/addTrip', data: data);

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log(" Error: $err");
      rethrow;
    }
  }
}
