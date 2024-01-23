import 'package:get/get.dart';
import 'package:gti_rides/screens/Partner/home/manage_vehicle/manage_vehicle_controller.dart';
import 'package:gti_rides/screens/Partner/home/partner_home_controller.dart';
import 'package:gti_rides/screens/Partner/payment/payment_controller.dart';
import 'package:gti_rides/screens/shared_screens/more/more_controller.dart';
import 'package:gti_rides/services/logger.dart';

class PartnerLandingController extends GetxController {
  Logger logger = Logger('PartnerLandingController');

  RxBool isDone = false.obs;

  PartnerLandingController() {
    logger.log('Controller initialized');
  }
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    Get.delete<MoreController>();
    Get.delete<PaymentController>();
    Get.put<MoreController>(MoreController());
    Get.delete<PartnerHomeController>();
    Get.put<PaymentController>(PaymentController());
    Get.put<PartnerHomeController>(PartnerHomeController());
    super.onInit();
    Get.delete<ManageVehicleController>();
    Get.put<ManageVehicleController>(ManageVehicleController());
  }
}
