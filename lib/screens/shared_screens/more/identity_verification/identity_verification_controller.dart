import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/renter/trip_data_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/car_selection_result_controller.dart';
import 'package:gti_rides/services/auth_service.dart';
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
  final carSelectionController = Get.put(CarSelectionResultController());

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

    if (arguments != null) {
      logger.log("Received arguments: $arguments");
      isKycUpdate.value = arguments?['isKycUpdate'] ?? false;
      appBarTitle.value = arguments?['appBarTitle'] ?? '';
      if (arguments!.containsKey('tripData')) {
        tripData.value = arguments?["tripData"] as TripData;
        logger.log("trip data:: ${tripData.value.tripType ?? 'lol'}");
      }
      logger.log("${tripData.value.carID}");

      pricePerDay.value = arguments?["pricePerDay"] ?? '';
      estimatedTotal.value = arguments?["estimatedTotal"] ?? '';
      vatValue.value = arguments?["vatValue"] ?? '';
      vat.value = arguments?["vat"] ?? '';
      tripDaysTotal.value = arguments?["tripDaysTotal"] ?? '';
      totalEscortFee.value = arguments?["totalEscortFee"] ?? '';
      tripType.value = arguments?["tripType"] ?? 0;
      selectedSelfPickUp.value = arguments?["selectedSelfPickUp"] ?? false;
      selectedSelfDropOff.value = arguments?["selectedSelfDropOff"] ?? false;
      selectedSecurityEscort.value =
          arguments?["selectedSecurityEscort"] ?? false;

      // tripDays.value = arguments?["tripDays"];
      // cautionFee.value = arguments?["cautionFee"];
      // dropOffFee.value = arguments?["dropOffFee"];
      // cautionFee.value = arguments?["cautionFee"];
      // pickUpFee.value = arguments?["pickUpFee"];
      // escortFee.value = arguments?["escortFee"];
    }
  }

  @override
  void onInit() async {
    update();

    logger.log(" on intit");
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Map<String, dynamic>? arguments = Get.arguments;

  PageController pageController = PageController();
  // TextEditingController homeAddressController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController emergencyNumberController = TextEditingController();
  TextEditingController emergencyNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController relationshipController = TextEditingController();
  final animationValue = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isImageUploadRequired = false.obs;
  // RxBool selectedIdType = false.obs;
  RxBool selectedNationalID = false.obs;
  RxBool selectedPassport = false.obs;
  RxBool selectedDriversLicense = false.obs;
  Rx<String> selectedDateOfBirth = ''.obs;

  Rx<String> testString = 'hello world'.obs;
  Rx<String> selectedGender = ''.obs;
  // Rx<String> pickedImagePath = ''.obs;
  Rx<String> pickedImageName = ''.obs;

  Rx<bool> isKycUpdate = false.obs;
  Rx<String> appBarTitle = ''.obs;
  Rx<TripData> tripData = TripData().obs;
  Rx<String> pricePerDay = ''.obs;
  Rx<int> tripDays = 0.obs;
  Rx<String> estimatedTotal = ''.obs;
  Rx<String> formattedVatValue = ''.obs;
  Rx<String> vatValue = ''.obs;
  Rx<String> cautionFee = ''.obs;
  Rx<String> vat = ''.obs;
  Rx<String> dropOffFee = ''.obs;
  Rx<String> pickUpFee = ''.obs;
  Rx<String> escortFee = ''.obs;
  Rx<String> tripDaysTotal = ''.obs;
  RxBool selectedSecurityEscort = false.obs;
  RxBool selectedSelfPickUp = false.obs;
  RxBool selectedSelfDropOff = false.obs;
  Rx<int> tripType = 0.obs;
  Rx<String> totalEscortFee = ''.obs;

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
  void routeToDob() => routeService.gotoRoute(AppLinks.dob);

  // void onSelectIdType() => selectedIdType.value = !selectedIdType.value;

  void onClickPrevious() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // void openCamera() async {
  //   ImageResponse? response =
  //       await imageService.pickImage(source: ImageSource.camera);
  //   if (response != null) {
  //     // Check if pickedImagePath is not null before accessing its value
  //     pickedImagePath.value = response.imagePath.split('/').last;
  //     logger.log("image path :: ${pickedImagePath.value}");
  //   }
  // }

  // void openGallery() async {
  //   ImageResponse? response =
  //       await imageService.pickImage(source: ImageSource.gallery);
  //   if (response != null) {
  //     logger.log("imagePath $pickedImagePath");
  //     pickedImagePath.value = response.imagePath;
  //     pickedImageName.value = response.imagePath.split('/').last;
  //   }
  // }

  void proceedToPayment() {
    routeService.gotoRoute(AppLinks.paymentSummary, arguments: {
      "isKycUpdate": isKycUpdate.value,
      "tripData": tripData.value,
      "pricePerDay": carSelectionController.pricePerDay.value,
      "tripDays": carSelectionController.tripDays.value,
      "estimatedTotal": estimatedTotal.value,
      "vatValue": carSelectionController.formattedVatValue.value,
      "vat": carSelectionController.vatValue.value,
      "cautionFee":
          carSelectionController.tripType.value == 1 ? cautionFee.value : null,
      "dropOffFee": carSelectionController.tripType.value == 1 &&
              carSelectionController.selectedSelfDropOff.value
          ? dropOffFee.value
          : null,
      "pickUp": carSelectionController.tripType.value == 1 &&
              carSelectionController.selectedSelfPickUp.value
          ? pickUpFee.value
          : null,
      "totalEscortFee": totalEscortFee.value,
      "tripDaysTotal": tripDaysTotal.value,
      "selectedSelfPickUp": selectedSelfPickUp.value,
      "selectedSelfDropOff": selectedSelfDropOff.value,
      "selectedSecurityEscort": selectedSecurityEscort.value,
      "tripType": tripType.value,

      // "startDateTime": startDateTime.value,
      // "endDateTime": endDateTime.value,
    });
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

  // bool validateImageUpload() {
  //   if (pickedImagePath.value.isEmpty) {
  //     // Show an error message or handle it accordingly
  //     showErrorSnackbar(message: 'Please upload an image.');
  //     return false;
  //   }
  //   return true;
  // }

  Future<void> updateKyc() async {
    if (!updateFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      Future<dio.FormData> constructFormData() async {
        var formData = dio.FormData.fromMap({});

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
        // if (pickedImagePath.value.isNotEmpty &&
        //     homeAddressController.text.isNotEmpty) {
        //   formData.fields.add(
        //     MapEntry(
        //       'file',
        //       await dio.MultipartFile.fromFile(
        //         pickedImagePath.value,
        //         filename: pickedImagePath.value,
        //       ).toString(),
        //     ),
        //   );
        //   formData.fields
        //       .add(MapEntry('homeAddress', homeAddressController.text));
        // }

        if (emergencyNameController.text.isNotEmpty &&
            emergencyNameController.text.isNotEmpty &&
            relationshipController.text.isNotEmpty) {
          formData.fields.add(
            MapEntry('emergencyNumber', emergencyNumberController.text),
          );
          formData.fields.add(
            MapEntry('emergencyName', emergencyNameController.text),
          );
          formData.fields.add(
            MapEntry('emergencyRelationship', relationshipController.text),
          );
        }

        if (selectedGender.isNotEmpty || selectedGender.value != '') {
          formData.fields.add(
            MapEntry('gender', selectedGender.string),
          );
        }
        if (selectedDateOfBirth.value.isNotEmpty) {
          formData.fields.add(
            MapEntry('dateOfBirth', selectedDateOfBirth.value),
          );
        }

        return formData;
      }

      final formData = await constructFormData();
      final result = await userService.updateKyc(payload: formData);

      if (result.status == "success" || result.status_code == 200) {
        routeService.goBack;
        logger.log("update KYC response ${result.data}");
        await showSuccessSnackbar(message: result.message!);
        final response = await userService.getKycProfile();
        if (response.status == "success" || response.status_code == 200) {
          final ListResponseModel userModel =
              ListResponseModel.fromJson(response.data?[0]);
          // Check if the response data list is not empty
          if (response.data != null || response.data != []) {
            userKyc.value = userModel;
            userService.setUserKyc(response.toJson());
            userKyc.refresh();
            update();
          }
          Future.delayed(Duration(seconds: 2))
              .then((value) => routeService.goBack(closeOverlays: true));

          Navigator.pop;
        }

        // routeService.goBack;
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
