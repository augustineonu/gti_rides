import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gti_rides/services/logger.dart';


GoogleSignInService get googleSignInService => Get.find();

class GoogleSignInService {
  Logger logger = Logger("GoogleSignInService");

  Future<Map<String, dynamic>>? signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // Google sign-in canceled
        return {};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String fullName = googleUser.displayName!;
      final String email = googleUser.email;
      final String googleAccessToken = googleAuth.accessToken!;
      final String googleId = googleUser.id;

      logger.log("Google credentials: $email $googleAccessToken $googleId");

      return {
        "fullName": fullName,
        "email": email,
        "googleAccessToken": googleAccessToken,
        "googleId": googleId,
      };
    } catch (e) {
      rethrow;
    }
  }
}
