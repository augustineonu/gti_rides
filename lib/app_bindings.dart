import 'package:get/get.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'route/app_links.dart';
import 'services/logger.dart';

class AppBinding extends Bindings {
  Logger logger = Logger('AppBinding');

  @override
  void dependencies() {
    logger.log('loading dependencies');
    // Get.put(DeviceService());
    Get.put(AppLinks());
    // Get.put(StorageService());
    Get.put(RouteService());
    Get.put(ImageService());
    // Get.put(ApiService());
    // Get.put(AuthService());
    // Get.put(AppService());
    // Get.put(FirebaseService());
    // Get.put(AgentService());
    // Get.put(TokenService());
    // Get.put(BiometricService());
    // Get.put(EncryptionService());
    // Get.put(ProfileService());
    // Get.put(NotificationService());
    // Get.put(SocketService());
    // Get.put(OrderService());
  }
}