import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';

ProfileService get profileService => Get.find();

class ProfileService {
  Logger logger = Logger('ProfileService');

    // Rx<User> user = User().obs;
  static final ProfileService _cache = ProfileService._internal();

  factory ProfileService() {
    return _cache;
  }

  ProfileService._internal() {
    init();
  }

  void init() {
    logger.log('Initializing profile service');
  }

  getProfile({String? token}) async {
    // try {
    //   final ApiResponseModel result = await authService.getProfile();

    //   user.value = User.fromJson(result.data);
    //   if (_getxStorageService.readData('passcode_setup') != null) {
    //     await BiometricPasscodeService.saveUserData(User.fromJson(result.data));
    //   }
    // } catch (e) {
    //   log("getProfile ${e.toString()}");
    // }
  }
}