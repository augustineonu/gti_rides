import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/banks_model.dart';
import 'package:gti_rides/models/drivers_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/screens/car%20owner/home/list_vehicle/list_vehicle_screen.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class PaymentController extends GetxController {
  Logger logger = Logger("Controller");

  PaymentController() {
    init();
  }

  void init() {
    logger.log("PaymentController Initialized");
  }

  @override
  void onInit() async {
    pageController.addListener(() {
      update();
    });
    super.onInit();
  }

  // variables
  RxBool isLoading = false.obs;
  RxBool addedPaymentMethod = false.obs;
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;
  RxString testString = "".obs;
  RxInt paymentMethodView = 0.obs;

  TextEditingController senderNameController = TextEditingController();

  final TextEditingController pinController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final FocusNode focus = FocusNode();
  
  
  List<Map<String, dynamic>> listOfBanksAsMap  = [
  BanksModel(id: "1", name: "Access Bank", code: "044"),
  BanksModel(id: "2", name: "Citibank", code: "023"),
  BanksModel(id: "3", name: "Diamond Bank", code: "063"),
  BanksModel(id: "4", name: "Dynamic Standard Bank", code: ""),
  BanksModel(id: "5", name: "Ecobank Nigeria", code: "050"),
  BanksModel(id: "6", name: "Fidelity Bank Nigeria", code: "070"),
  BanksModel(id: "7", name: "First Bank of Nigeria", code: "011"),
  BanksModel(id: "8", name: "First City Monument Bank", code: "214"),
  BanksModel(id: "9", name: "Guaranty Trust Bank", code: "058"),
  BanksModel(id: "10", name: "Heritage Bank Plc", code: "030"),
  BanksModel(id: "11", name: "Jaiz Bank", code: "301"),
  BanksModel(id: "12", name: "Keystone Bank Limited", code: "082"),
  BanksModel(id: "13", name: "Providus Bank Plc", code: "101"),
  BanksModel(id: "14", name: "Polaris Bank", code: "076"),
  BanksModel(id: "15", name: "Stanbic IBTC Bank Nigeria Limited", code: "221"),
  BanksModel(id: "16", name: "Standard Chartered Bank", code: "068"),
  BanksModel(id: "17", name: "Sterling Bank", code: "232"),
  BanksModel(id: "18", name: "Suntrust Bank Nigeria Limited", code: "100"),
  BanksModel(id: "19", name: "Union Bank of Nigeria", code: "032"),
  BanksModel(id: "20", name: "United Bank for Africa", code: "033"),
  BanksModel(id: "21", name: "Unity Bank Plc", code: "215"),
  BanksModel(id: "22", name: "Wema Bank", code: "035"),
  BanksModel(id: "23", name: "Zenith Bank", code: "057"),
].map((bank) => bank.toJson()).toList();


// routing methods

  void changeView() {
    paymentMethodView.value == 1;
  }

  void goBack() => routeService.goBack();
  void routeToQuickEdit() => routeService.gotoRoute(AppLinks.quickEdit);
  void routeToCarHistory() => routeService.gotoRoute(AppLinks.carHistory);
  void routeToCompletedTrip() => routeService.gotoRoute(AppLinks.completedTrip);
  void routeToVerifyOtp() => routeService.gotoRoute(AppLinks.verifyAccountOtp);
    void onFocusChange() => update();

  void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied);
  }

    @override
  void dispose() {
    super.dispose();
    pinController.dispose();
    focus
      ..removeListener(onFocusChange)
      ..dispose();
  }
}
