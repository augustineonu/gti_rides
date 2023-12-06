import 'package:get/get.dart';
import 'package:gti_rides/models/api_response_model.dart';
import 'package:gti_rides/services/auth_service.dart';
import 'package:gti_rides/services/logger.dart';


TokenService get tokenService => Get.find();

class TokenService {
  Logger logger = Logger('TokenService');
  // Rx<Tokens> tokens = Tokens().obs;
  RxString accessToken = ''.obs;
  RxString refreshToken = ''.obs;

  static final TokenService _cache = TokenService._internal();

  factory TokenService() {
    return _cache;
  }

  TokenService._internal() {
    init();
  }

  void init() {
    logger.log('Initializing token service');
  }

  Future<bool> setTokenModel(tokensJson) async {
    // tokens.value = Tokens.fromJson(tokensJson);
    // come to this later #TODO: 
    // await biometricService.saveTokensData(tokens.value);
    return true;
  }

  bool setAccessToken(token) {
    accessToken.value = token;
    return true;
  }

  bool setRefreshToken(token) {
    refreshToken.value = token;
    return true;
  }

  Future<bool> getNewAccessToken() async {
    try {
      final ApiResponseModel result =
          await authService.getNewAccessToken(refreshToken: refreshToken.value);
      if (result.status == 'error'.toLowerCase()) {
        return false;
      }

      await setTokenModel(result.data);
      // setAccessToken(tokens.value.accessToken);
      // setRefreshToken(tokens.value.refreshToken);

      return true;
    } catch (error) {
      return false;
    }
  }
}
