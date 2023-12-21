import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

enum IdType { nationalId, passport, driverLicense }

class IdentityVerificationController extends GetxController {
  Logger logger = Logger("Controller");

  Rx<UserModel> user = UserModel().obs;
  Rx<ListResponseModel> userKyc = ListResponseModel().obs;

  GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  IdentityVerificationController() {
    init();
  }

  void init() async {
    logger.log("IdentityVerificationController Initialized");
    // await getBiometricProfile();
    user = userService.user;
    logger.log("USER: ${user.value.toJson()}");

    userKyc = userService.userKyc;
    logger.log("USER Kyc Details: ${userKyc.value.toJson()}");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  PageController pageController = PageController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController emergencyContactController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController relationshipController = TextEditingController();
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  // RxBool selectedIdType = false.obs;
  RxBool selectedNationalID = false.obs;
  RxBool selectedPassport = false.obs;
  RxBool selectedDriversLicense = false.obs;

  Rx<String> testString = 'hello world'.obs;
  Rx<String> pickedImagePath = ''.obs;
  Rx<String> pickedImageName = ''.obs;

  // list
  List<String> gender = [
    AppStrings.male,
    AppStrings.female,
  ];

  void goBack() => routeService.goBack();
  void routeToPaymentSummary() =>
      routeService.gotoRoute(AppLinks.paymentSummary);
  void routeToProofOfIdentity() =>
      routeService.gotoRoute(AppLinks.proofOfIdentity);
  void routeToHomeAddress() => routeService.gotoRoute(AppLinks.homeAddress);
  void routeToOfficeAddress() => routeService.gotoRoute(AppLinks.officeAddress);
  void routeToOccupation() => routeService.gotoRoute(AppLinks.occupation);
  void routeToEmergencyContact() =>
      routeService.gotoRoute(AppLinks.emergencyContact);
  void routeToSelectGender() => routeService.gotoRoute(AppLinks.gender);

  // void onSelectIdType() => selectedIdType.value = !selectedIdType.value;

  Rx<IdType> selectedIdType = IdType.nationalId.obs;

  void onSelectIdType(IdType idType) {
    selectedIdType.value = idType;
  }

  void onPageChanged(int value) {
    currentIndex.value = value;
    pageController.animateToPage(
      value,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.ease,
    );
    update();
  }

  void onClickPrevious() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void openCamera() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.camera);
    if (response != null) {
      // Check if pickedImagePath is not null before accessing its value
      pickedImagePath.value = response.imagePath.split('/').last;
      logger.log("image path :: ${pickedImagePath.value}");
    }
  }

  void openGallery() async {
    ImageResponse? response =
        await imageService.pickImage(source: ImageSource.gallery);
    if (response != null) {
      logger.log("imagePath $pickedImagePath");
      pickedImagePath.value = response.imagePath;
      pickedImageName.value = response.imagePath.split('/').last;
    }
  }

  Future<void> getBiometricProfile() async {
    try {
      final response = await userService.getKycProfile();

      if (response.status == "success" || response.status_code == 200) {
        logger.log("User KYC ${response.data.toString()}");
        // Check if the response data list is not empty
        if (response.data != null || response.data != []) {
          userKyc.value = response;
        }
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    }
  }

  
  bool validateImageUpload() {
  if (pickedImagePath.value.isEmpty) {
    // Show an error message or handle it accordingly
    showErrorSnackbar(message: 'Please upload an image.');
    return false;
  }
  return true;
}
  Future<void> updateKyc() async {
    if (!updateFormKey.currentState!.validate() || !validateImageUpload()) {
      return;
    }

    isLoading.value = true;

    try {
      Future<dio.FormData> constructFormData() async {
        var formData = dio.FormData();

        // Check if fullName is not empty before adding it to formData
        if (officeAddressController.text.isNotEmpty) {
          formData.fields
              .add(MapEntry('officeAddress', officeAddressController.text));
        }
        if (occupationController.text.isNotEmpty) {
          formData.fields
              .add(MapEntry('occupation', occupationController.text));
        }
        // Check if imagePath is not empty before adding the image file to formData
        if (pickedImagePath.value.isNotEmpty &&
            homeAddressController.text.isNotEmpty) {
          formData.files.add(
            MapEntry(
              'file',
              await dio.MultipartFile.fromFile(
                pickedImagePath.value,
                filename: pickedImagePath.value,
              ),
            ),
          );
          formData.fields
              .add(MapEntry('homeAddress', homeAddressController.text));
        }
        return formData;
      }

      final formData = await constructFormData();
      final result = await userService.updateKyc(payload: formData);

      if (result.status == "success" || result.status_code == 200) {
        logger.log("update KYC response ${result.data}");
        await showSuccessSnackbar(message: result.message!);
        // final response = await authService.getProfile();
        // if (response.status == "success" || response.status_code == 200) {
        //   logger.log("refresh user details ${response.data.toString()}");
        //   final UserModel userModel = UserModel.fromJson(response.data?[0]);
        //   userService.setCurrentUser(userModel.toJson());
        //   routeService.goBack;
        // }
        // routeService.offAllNamed(AppLinks.more);
        // routeService.goBack;
        // Get.back();
      } else {
        logger.log("error updating user: ${result.message}");
        await showErrorSnackbar(message: result.message!);
        routeService.goBack;
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
