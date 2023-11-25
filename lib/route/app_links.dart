import 'package:get/get.dart';

AppLinks get appLinks => Get.find();

class AppLinks {
  static final AppLinks _cache = AppLinks._internal();

  factory AppLinks() {
    return _cache;
  }

  AppLinks._internal();

  static const welcome = "/";
  static const login = "/login";
  static const splash = "/splash";
  static const onboarding = "/onboarding";
  static const signUp = "/signUp";
  static const emailOtp = "/emailOtp";
  static const verifyOtp = "/verifyOtp";
  static const requestResetPassword = "/requestResetPassword";
  static const resetPassword = "/resetPassword";
  static const welcomeBack = "/welcome-back";
  static const agentHome = "/home";
  static const currentOrders = "/orders/currentOrders";
  static const notification = "/notification";
  static const waitingOrders = "/orders/waitingOrders";
  static const completedOrders = "/orders/completedOrders";
  static const orderDetails = "/orders/waitingOrders/orderDetails";
  static const performance = "/performance";
  static const settings = "/settings";
  static const landingPage = "/landingPage";
  static const searchCity = "/searchCity";
  static const chooseTripDate = "/chooseTripDate";
  static const searchResult = "/searchResult";
  static const searchFilter = "/searchFilter";
  static const carSelectionResult = "/carSelectionResult";
  static const reviews = "/reviews";
  static const viewCar = "/viewCar";
  static const kycCheck = "/kycCheck";
  static const updateKyc = "/renter/searchResult/carSelectionResult/updateKyc";
  static const paymentSummary =
      "/renter/searchResult/carSelectionResult/paymentSummary";
  static const more = "/renter/more";
  static const chooseSingleDateTrip = "/renter/trips/chooseSingleDateTrip";
  static const profile = "/renter/more/profile";
  static const favorite = "/renter/more/favorite";
  static const accountDetails = "/renter/more/accountDetails";
  static const email = "/email";
  static const phoneInput =
      "/renter/more/account_details/account_verification/phoneInput";
  static const phoneOtp = "/renter/more/account_details/account_verification/phoneOtp";
  static const changePassword = "/renter/more/account_details/changePassword";
  static const identityVerification = "/renter/more/identityVerification";
  static const proofOfIdentity = "/renter/more/identityVerification/proofOfIdentity";
  static const homeAddress = "/renter/more/identityVerification/homeAddress";
  static const officeAddress = "/renter/more/identityVerification/officeAddress";
  static const emergencyContact = "/renter/more/identityVerification/emergencyContact";
  static const occupation = "/renter/more/identityVerification/occupation";

  // static const chatAction = "/user/chat/:key/:action";

  final links = {
    "welcome": welcome,
    "login": login,
    "splash": splash,
    "emailOtp": emailOtp,
    "phoneOtp": phoneOtp,
    "verifyOtp": verifyOtp,
    "resetPassword": resetPassword,
    "requestResetPassword": requestResetPassword,
    "agentHome": agentHome,
    "welcomeBack": welcomeBack,
    "currentOrders": currentOrders,
    "waitingOrders": waitingOrders,
    "completedOrders": completedOrders,
    "orderDetails": orderDetails,
    "settings": settings,
    "landingPage": landingPage,
    'searchCity': searchCity,
    'chooseTripDate': chooseTripDate,
    'searchResult': searchResult,
    'searchFilter': searchFilter,
    'carSelectionResult': carSelectionResult,
    'reviews': reviews,
    'viewCar': viewCar,
    'kycCheck': kycCheck,
    'updateKyc': updateKyc,
    'paymentSummary': paymentSummary,
    'more': more,
    'chooseSingleDateTrip': chooseSingleDateTrip,
    'profile': profile,
    'favorite': favorite,
    'accountDetails': accountDetails,
    'email': email,
    'phoneInput': phoneInput,
    'changePassword': changePassword,
    'identityVerification': identityVerification,
    'proofOfIdentity': proofOfIdentity,
    'homeAddress': homeAddress,
    'officeAddress': officeAddress,
    'occupation': occupation
    // 'trips': trips,
  };

  String url(String endpoint,
      {Map<String, String>? params, bool parse = true}) {
    var path = links[endpoint]!;
    if (parse) {
      path = parsePath(path, params: params);
    }
    return path;
  }

  String parsePath(String path, {Map<String, String>? params}) {
    if (params != null) {
      params.forEach((key, value) {
        path = path.replaceAll(":$key", value);
      });
    }
    final varPattern = RegExp(r'(?<!:):\w+');
    path = path.replaceAll(varPattern, '');
    final slashPattern = RegExp(r'\/+$');
    path = path.replaceAll(slashPattern, '');
    return path;
  }
}
