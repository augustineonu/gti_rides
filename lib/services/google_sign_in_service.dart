import 'dart:io';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:dio/dio.dart';

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
    } on DioException catch (e) {
      logger.log("GOOGLE SIGNIN REQUEST ERROR :: ${e.response?.data}");

      if (e.response?.data != null) {
        return e.response?.data;
      }
      throw "An error occurred";
    } on SocketException {
      throw "seems you are offline";
    } catch (e) {
      rethrow;
    }
  }
}
