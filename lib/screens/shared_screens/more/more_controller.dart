import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/auth/token_model.dart';
import 'package:gti_rides/models/list_response_model.dart';
import 'package:gti_rides/models/user_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/payment_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../services/route_service.dart';

class MoreController extends GetxController {
  Logger logger = Logger('MoreController');

  Rx<UserModel> user = UserModel().obs;
  Rx<TokenModel> tokens = TokenModel().obs;
  Rx<ListResponseModel> userKyc = ListResponseModel().obs;

  MoreController() {
    init();
  }

  void init() async {
    logger.log('MoreController initialized');

    await getKycProfile();
    // paymentService.getBankAccount();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    user = userService.user;
    logger.log("User:: ${user.value}");
    if (!isLogout.value) {
      tokens.value = (await tokenService.getTokensData()) ?? TokenModel();
    }
    logger.log("User:: ${tokens.value.userType}");
    logger.log("User token && User type:: $tokens");
    super.onInit();
    // Hustinken19891
  }

  // late Timer timer;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  // late PageController cardPageController;
  ScrollController scrollController = ScrollController();
  GlobalKey<FormState> deactivateAccountFormKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  RxBool isLogout = false.obs;
  RxBool isDone = false.obs;
  RxBool showPassword = false.obs;
  Rx<String> exampleText = "".obs;
  RxList<dynamic>? drivers = <dynamic>[].obs;

  List<Map<String, dynamic>> profileOptions = [
    {
      'image': ImageAssets.personIcon1,
      'title': " ${AppStrings.accountDetails}",
    },
    {'image': ImageAssets.heart, 'title': AppStrings.favorite},
    {
      'image': ImageAssets.note1,
      'title': " ${AppStrings.identityVerification}"
    },
    {'image': ImageAssets.toyCar, 'title': AppStrings.myDrivers},
    {'image': ImageAssets.key, 'title': "  ${AppStrings.howGtiWorks1}"},
    {'image': ImageAssets.people, 'title': "  ${AppStrings.referrals}"},
    {'image': ImageAssets.headSet, 'title': "  ${AppStrings.reportAnIncident}"},
    {
      'image': ImageAssets.headSet,
      'title': "  ${AppStrings.contactCustomerCare}"
    },
    {'image': ImageAssets.notification, 'title': AppStrings.notification},
  ];

  void routeToNotification() => routeService.gotoRoute(AppLinks.notification);
  void routeToPasswordConfirmation() =>
      routeService.gotoRoute(AppLinks.deactivateAccountPassword);

  onPageChanged(int index) {}
  // RxBool showPassword = true.obs;

  void obscurePassword() => showPassword.value = !showPassword.value;

  Future<void> logOut() async {
    // isLogout.value = true;
    logger.log("value ${isLogout}");
    // return;
    await tokenService.clearAll();
    await userService.deleteUserData();
    logger.log("User:: ${userService.user.value.fullName}");
    // storageService.remove('firstTimeLogin');
    routeService.offAllNamed(AppLinks.login);
  }

  Future<void> shareRide({required String content}) async =>
      Share.share('${AppStrings.websiteUrl}$content');
  // update();

  // navigation method
  void goBack() => routeService.goBack();
  void routeToSignUp() => routeService.gotoRoute(AppLinks.signUp);
  void routeToLandingPage() =>
      routeService.gotoRoute(AppLinks.carRenterLanding);
  void routeToSearchCity() => routeService.gotoRoute(AppLinks.searchCity);
  void routeToProfile() => routeService.gotoRoute(AppLinks.profile);
  void routeToFavorite() => routeService.gotoRoute(AppLinks.favorite);
  void routeToAccountDetails() =>
      routeService.gotoRoute(AppLinks.accountDetails);
  void routeToIdentityVerification() =>
      routeService.gotoRoute(AppLinks.identityVerification);
  void routeToReferralCode() => routeService.gotoRoute(AppLinks.referral);
  void routeToDrivers() => routeService.gotoRoute(AppLinks.drivers);

  void launchWebsite() => openUrl(AppStrings.websiteUrl);

  void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied);
  }

  Future<void> launchMessenger() async {
    await Intercom.instance
        .loginIdentifiedUser(email: userService.user.value.emailAddress);
    await Intercom.instance.displayMessenger();
  }

  Future<void> getKycProfile() async {
    isLoading.value = true;
    try {
      final response = await userService.getKycProfile();

      if (response.status == "success" || response.status_code == 200) {
        logger.log("User KYC ${response.data.toString()}");
        final ListResponseModel userModel =
            ListResponseModel.fromJson(response.data?[0]);
        // Check if the response data list is not empty
        if (response.data != null || response.data != []) {
          userKyc.value = userModel;
          userService.setUserKyc(response.toJson());
        }
      }
    } catch (e) {
      logger.log("error rrr: $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDrivers() async {
    try {
      final response = await partnerService.getDrivers();
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("gotten drivers ${response.data}");
        if (response.data != null) {
          drivers?.value = response.data!;
          logger.log("drivers $drivers");
        }
      } else {
        logger.log("unable to get drivers ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    }
  }

  Future<void> deactivateAccount() async {
    if (!deactivateAccountFormKey.currentState!.validate()) {
      return;
    }
    try {
      final response = await userService.deactivateAccount(payload: {
        "user":
            userService.user.value.emailAddress ?? "", // email or phone number
        "password": passwordController.text
      });
      if (response.status == 'success' || response.status_code == 200) {
        logger.log("Deactivated account");
        await logOut();
      } else {
        showErrorSnackbar(message: response.message.toString());
        logger.log("Unable to deactivate account ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
      showErrorSnackbar(message: exception.toString());
    }
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    // timer.cancel(); // Cancel the timer when the controller is disposed.
    super.onClose();
  }
}
