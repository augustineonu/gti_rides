import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/models/banks_model.dart';
import 'package:gti_rides/route/app_links.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/payment_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';

class PaymentController extends GetxController with StateMixin<List<dynamic>> {
  Logger logger = Logger("Controller");

  final ScrollController scrollController = ScrollController();

  PaymentController() {
    init();
  }

  void init() async {
    logger.log("PaymentController Initialized");
    addedPaymentMethod.value == true;
    logger.log("User type:: ${userService.user.value.userType}");
    if (userService.user.value.userType == "partner") {
      await getBanks();
      await getBankAccount();
      await getPaymentList();
      // await getBankAccount();
    }
  }

  @override
  void onInit() async {
    logger.log("value:: $paymentList");
    pageController.addListener(() {
      update();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          isLoadingMore.value) {
        getPaymentList(isLoadMore: true);
      }
    });
    super.onInit();

    // addedPaymentMethod.value = true;
  }

  // variables
  RxBool isLoading = false.obs;
  RxBool addedPaymentMethod = false.obs;
  RxBool isFetchingAccountDetails = false.obs;
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;
  RxString testString = "".obs;
  RxInt paymentMethodView = 0.obs;
  Rx<String> bankName = ''.obs;
  Rx<String> bankCode = ''.obs;
  Rx<String> accountName = ''.obs;
  Rx<Map<String, dynamic>>? selectedBank = Rx<Map<String, dynamic>>({});
  // static Rx<Map<String, String>> ex = Rx<Map<String, String>>({
  //   '50': "50",
  //   '100': "100",
  //   '150': "150",
  //   '250': "250",
  // });

  TextEditingController fullNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();

  final TextEditingController pinController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final FocusNode focus = FocusNode();
  GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();

  List<BanksModel> listOfBanks = [];

  List<Map<String, dynamic>> listOfBanksAsMap = [
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
    BanksModel(
        id: "15", name: "Stanbic IBTC Bank Nigeria Limited", code: "221"),
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
  void goBack1() => routeService.goBack(closeOverlays: true);
  void routeToQuickEdit() => routeService.gotoRoute(AppLinks.quickEdit);
  void routeToCarHistory() => routeService.gotoRoute(AppLinks.carHistory);
  void routeToCompletedTrip() => routeService.gotoRoute(AppLinks.completedTrip);
  void routeToVerifyOtp() =>
      routeService.gotoRoute(AppLinks.verifyAccountOtp, arguments: {
        "email": userService.user.value.emailAddress,
        "fullName": fullNameController.text,
        "bankName": bankName.value,
        "bankCode": bankCode.value,
        "accountNumber": accountNumberController.text,
      });
  void onFocusChange() => update();

  void copy({required String value}) async {
    await Clipboard.setData(ClipboardData(text: value));

    await showSuccessSnackbar(message: AppStrings.copied);
  }

  Future<void> requestOtp() async {
    if (!paymentFormKey.currentState!.validate()) {
      return;
    }
    ApiResponseModel result;
    try {
      isLoading.value = true;

      result = await authService
          .resendOtp(payload: {"user": userService.user.value.emailAddress});

      if (result.message == "success" || result.status_code == 200) {
        await showSuccessSnackbar(message: "Kindly verifyfy OTP to continue");
        paymentMethodView.value = 0;
        isLoading.value = false;

        routeToVerifyOtp();

        // routeService.getOff(() => const PhoneVerificationScreen(), arguments: {
        //   'email': userService.user.value.emailAddress,
        //   "newPhoneNumber": phoneController.text,
        // });
      } else {
        await showErrorSnackbar(message: result.message!);
        isLoading.value = true;
        logger.log("error requesting OTP${result.message!}");
      }
    } catch (e) {
      logger.log("error : $e");
      showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveBankDetails() async {
    if (!paymentFormKey.currentState!.validate()) {
      return;
    }
    routeToVerifyOtp();
  }

  Future<void> getBanks() async {
    // change(<BanksModel>[].obs, status: RxStatus.loading());

    try {
      final response = await paymentService.getBanks();

      if (response.status == 'success' || response.status_code == 200) {
        // logger.log("gotten banks ${response.data}");
        if (response.data != null && response.data!.isNotEmpty) {
          listOfBanksAsMap = response.data!.cast<Map<String, dynamic>>();

          // Sort the list alphabetically by the 'name' attribute
          listOfBanksAsMap.sort((a, b) {
            return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
          });
          // response.data!.cast<BanksModel>();
          // change(response.data!.cast<BanksModel>(), status: RxStatus.success());
          // logger.log("car history $carHistory");
        } else {
          change(<BanksModel>[].obs, status: RxStatus.empty());
        }
      } else {
        logger.log("unable to get banks ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
      change(<BanksModel>[].obs, status: RxStatus.error(exception.toString()));
    }
  }

  Future<void> getBankAccount() async {
    change(<dynamic>[].obs, status: RxStatus.loading());

    try {
      final response = await paymentService.getBankAccount();

      if (response.status == 'success' || response.status_code == 200) {
        // logger.log("gotten bank account ${response.data}");
        if (response.data != null && response.data!.isNotEmpty) {
          // listOfBanksAsMap = response.data!.cast<Map<String, dynamic>>();
          addedPaymentMethod.value == true;
          paymentMethodView.value == 0;
          change(response.data!, status: RxStatus.success());
          fullNameController.text = response.data?.first['fullName'];
          // fullNameController = TextEditingController(text: response.data?.first['fullName']);
          accountNumberController.text = response.data?.first['accountNumber'];
          selectedBank?.value = response.data?.first;
          logger.log("fullName:: ${fullNameController.text}");

          // logger.log("car history $carHistory");
        } else {
          change(<dynamic>[].obs, status: RxStatus.empty());
        }
      } else {
        logger.log("unable to get bank account ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
      change(<dynamic>[].obs, status: RxStatus.error(exception.toString()));
    }
  }

  RxBool isGettingPaymentList = false.obs;
  RxBool isGettingBankAccount = false.obs;
  // RxList<dynamic> paymentLIst = <Rx>[].obs;
  RxList<dynamic> paymentList = <dynamic>[].obs;

  var skip = 0;
  final int limit = 10;
  RxBool isLoadingMore = false.obs;
  

  Future<void> getPaymentList({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore.value = true;
      skip += limit;
    } else {
      isLoadingMore.value = false;
      skip = 0;
    }
    isGettingPaymentList.value = true;
    try {
      final response = await partnerService.getPaymentList(
        limit: limit, skip: skip
      );
      if (response.status == 'success' || response.status_code == 200) {
        // logger.log("gotten payment list ${response.data}");
        if (response.data != null && response.data!.isNotEmpty) {
          // paymentList.value = response.data!;
          if (isLoadMore) {
            paymentList.addAll(response.data!);
          } else {
            paymentList.value = response.data!.cast<dynamic>().obs;
          }

          // logger.log("payment list:: ${paymentList}");
          isGettingPaymentList.value = false;
        } else {
          logger.log('data is empty');
          if (!isLoadMore) {
            paymentList.value = [];
          }
        }
      } else {
        logger.log("unable to get payment list ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    } finally {
      isGettingPaymentList.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> resolveAccount() async {
    if (bankCode.value.isEmpty) {
      showErrorSnackbar(message: 'Kindly select bank');
      return;
    }
    if (accountNumberController.text.isEmpty) {
      // showErrorSnackbar(message: 'Kindly select input account number');
      return;
    }
    isFetchingAccountDetails.value = true;
    try {
      final response = await paymentService.resolveAccount(
          accountNumber: accountNumberController.text,
          accountCode: bankCode.value);

      if (response.status == 'success' || response.status_code == 200) {
        // logger.log("gotten account details ${response.data}");
        if (response.data != null && response.data!.isNotEmpty) {
          accountName.value = response.data['account_name'];
          fullNameController.text = response.data['account_name'];

          isFetchingAccountDetails.value = false;
        }
      } else {
        showErrorSnackbar(message: response.message!);
        logger.log("unable to resolve bank account ${response.data}");
      }
    } catch (exception) {
      logger.log("error  $exception");
    } finally {
      isFetchingAccountDetails.value = false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    fullNameController.clear();
    accountNumberController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    pinController.dispose();
    fullNameController.dispose();
    accountNumberController.dispose();
    focus
      ..removeListener(onFocusChange)
      ..dispose();
  }
}
