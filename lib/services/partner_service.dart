import 'dart:convert';

import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/services/api_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:dio/dio.dart' as dio;

PartnerService get partnerService => Get.find();

class PartnerService extends GetxController {
  Logger logger = Logger('PartnerService');
  // Rx<Agent> agentModel = Agent().obs;
  Rx<UserModel> user = UserModel().obs;
  RxList<Driver>? drivers = <Driver>[].obs;

  static final PartnerService _cache = PartnerService._internal();

  factory PartnerService() {
    return _cache;
  }

  PartnerService._internal() {
    init();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    logger.log("onInit called");
  }

  void init() async {
    logger.log('Initializing Partner service');
    // await getDrivers1();
  }

  Future<void> getDrivers1() async {
    try {
      final response = await partnerService.getDrivers();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten drivers ${response.data}");
        if (response.data != null) {
          drivers?.value = response.data! as dynamic;
          logger.log("drivers $drivers");
        }
      } else {
        logger.log("unable to get drivers ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    }
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

  Future<ListResponseModel> getVehicleYear(
      {required String brandCode, required String brandModelCode}) async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getVehicleYear?brandCode=$brandCode&brandModelCode=$brandModelCode',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getBrandModel({required String brandCode}) async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getBrandModel?brandCode=$brandCode',
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

  Future<ApiResponseModel> addCar({required Map data}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/partner/car/addCar', data: data);
      logger.log("result $result");

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("error $err");
      rethrow;
    }
  }

  Future<ApiResponseModel> addCarInfo(
      {required Map data, required String carId}) async {
    try {
      final result = await apiService.postRequest(
          endpoint: '/user/partner/car/addCarInfo?carID=$carId', data: data);
      logger.log("result $result");

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log("error $err");
      rethrow;
    }
  }

  Future<ListResponseModel> addDriver1({required dio.FormData data}) async {
    try {
      final result = await apiService.postRequestFile(
          endpoint: '/user/partner/driver/addDriver', data: data);
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      logger.log("error adding driver $err");
      rethrow;
    }
  }

  Future<ApiResponseModel> addDriver({required dio.FormData payload}) async {
    try {
      final result = await apiService.postRequestFile(
        endpoint: '/user/partner/driver/addDriver',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log(" Error: $err");
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

  Future<ListResponseModel> getVehicleSeats() async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getSeat',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getInsuranceType() async {
    try {
      final result = await apiService.getRequest(
        '/user/misc/getInsuranceType',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ListResponseModel> getDrivers() async {
    try {
      final result = await apiService.getRequest(
        '/user/partner/driver/getUsersDrivers',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }
  Future<ListResponseModel> getCars() async {
    try {
      final result = await apiService.getRequest(
        '/owner/cars/getCars',
      );
      logger.log("result $result");

      final decodedResult = json.decode(result);

      return ListResponseModel.fromJson(decodedResult);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponseModel> addCarAvailability(
      {required Map payload, required String carID}) async {
    try {
      final result = await apiService.postRequest(
        endpoint: '/user/partner/car/addCarAvailability?carID=$carID',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log(" Error: $err");
      rethrow;
    }
  }
  Future<ApiResponseModel> addCarDocument(
      {required dio.FormData payload, required String carID}) async {
    try {
      final result = await apiService.postRequestFile(
        endpoint: '/user/partner/car/addCarDocument?carID=$carID',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log(" Error: $err");
      rethrow;
    }
  }
  Future<ApiResponseModel> addCarPhoto(
      {required dio.FormData payload, required String carID}) async {
    try {
      final result = await apiService.postRequestFile(
        endpoint: '/user/partner/car/addCarPhoto?carID=$carID',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log(" Error: $err");
      rethrow;
    }
  }
  Future<ApiResponseModel> updateLicensePhoto(
      {required dio.FormData payload, required String driverID}) async {
    try {
      final result = await apiService.postRequestFile(
        endpoint: '/user/partner/driver/updateLicense?driverID=$driverID',
        data: payload,
      );

      return ApiResponseModel.fromJson(result);
    } catch (err) {
      logger.log(" Error: $err");
      rethrow;
    }
  }
}
