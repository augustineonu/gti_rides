
import 'package:get/get.dart';
import 'package:gti_rides/models/notification_model.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';

class ViewNotificationController extends GetxController {
  Logger logger = Logger('ViewNotificationController');
  ViewNotificationController() {
    init();
  }

  void init() {
    logger.log('Controller initialized');
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    if(arguments != null) {
      logger.log("received args:: $arguments");
      notificationData =  arguments!["notificationData"];

    }
    super.onInit();
  }

  // final  NotificationData? arguments = Get.arguments;
  final  Map<String, dynamic>? arguments = Get.arguments;
  NotificationData? notificationData;

  void goBack() => routeService.goBack();
}
