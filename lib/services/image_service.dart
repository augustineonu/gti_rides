import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:image_picker/image_picker.dart';

ImageService get imageService => Get.find();

class ImageService {
  static final ImageService _cache = ImageService();
  Logger logger = Logger("ImageService");

  RxString imagePath = ''.obs;

  Future<ImageResponse> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 25,
        // Reduce Image quality
        // maxHeight: 500,
        // reduce the image size
        // maxWidth: 500
      );
      Uint8List selectedImageBytes = await pickedFile!.readAsBytes();
      String selectedImagePath = pickedFile.path;
      return ImageResponse(
          imageBytes: selectedImageBytes, imagePath: selectedImagePath);
    } catch (e) {
      rethrow;
    }
  }
}
