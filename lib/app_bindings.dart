import 'package:get/get.dart';
import 'package:gti_rides/services/api_exception.dart';
import 'package:gti_rides/services/api_service.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/biometric_service.dart';
import 'package:gti_rides/services/device_service.dart';
import 'package:gti_rides/services/firesbase_service.dart';
import 'package:gti_rides/services/google_sign_in_service.dart';
import 'package:gti_rides/services/image_service.dart';
import 'package:gti_rides/services/more_service.dart';
import 'package:gti_rides/services/network_controller.dart';
import 'package:gti_rides/services/notification_servie.dart';
import 'package:gti_rides/services/partner_service.dart';
import 'package:gti_rides/services/payment_service.dart';
import 'package:gti_rides/services/renter_service.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/services/storage_service.dart';
import 'package:gti_rides/services/token_service.dart';
import 'package:gti_rides/services/user_service.dart';
import 'route/app_links.dart';
import 'services/logger.dart';

class AppBinding extends Bindings {
  Logger logger = Logger('AppBinding');

  @override
  void dependencies() {
    logger.log('loading dependencies');
    Get.put(DeviceService());
    Get.put(AppLinks());
    Get.put(StorageService());
    Get.put(RouteService());
    Get.put(ImageService());
    Get.put(ApiService());
    Get.put(AuthService());
    Get.put(GoogleSignInService());
    Get.put(RenterService());
    Get.put(UserService());
    Get.put(MoreService());
    Get.put(PartnerService());
    Get.put(PaymentService());
    Get.put(ApiExceptionService());
    Get.put(NetworkController(), permanent: true);
    // Get.put(AppService());
    // Get.put(FirebaseService());
    // Get.put(AgentService());
    Get.put(TokenService());
    Get.put(BiometricService());
    // Get.put(EncryptionService());
    // Get.put(ProfileService());
    // Get.put(NotificationService());

  }
}
