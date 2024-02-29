import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gti_rides/models/image_response.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

ImageService get imageService => Get.find();

class ImageService {
  static final ImageService _cache = ImageService();
  Logger logger = Logger("ImageService");

  // RxString imagePath = ''.obs;

  Future<ImageResponse?> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 25,
      );

      if (pickedFile == null) {
        // User canceled image selection
        return null;
      }

      // Uint8List selectedImageBytes = await pickedFile.readAsBytes();
      String selectedImagePath = pickedFile.path;
      return ImageResponse(
        // imageBytes: selectedImageBytes,
        imagePath: selectedImagePath,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ImageResponse>> pickMultipleImages() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      List<XFile>? imageFileList = await imagePicker.pickMultiImage();

      List<ImageResponse> responses = [];

      if (imageFileList != null && imageFileList.isNotEmpty) {
        for (XFile imageFile in imageFileList) {
          Uint8List selectedImageBytes = await imageFile.readAsBytes();
          String selectedImagePath = imageFile.path;

          responses.add(ImageResponse(
            imagePath: selectedImagePath,
          ));
        }
      }

      return responses;
    } catch (e) {
      rethrow;
    }
  }

  Future<ImageResponse?> pickDocument() async {
    try {
      // Check if permission is granted
      var status = await Permission.storage.status;
      if (status.isGranted) {
        FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc'],
        );

        if (pickedFile == null) {
          return null;
        }

        String selectedImagePath = pickedFile.files.single.path!;
        return ImageResponse(imagePath: selectedImagePath);
      } else {
        // Request permission
        var result = await Permission.storage.request();
        if (result.isGranted) {
          // Permission granted, try picking the file again
          return await pickDocument();
        } else if (status.isPermanentlyDenied) {
          // Permission denied
          openAppSettings();

          return null;
        }
      }
    } catch (e) {
      logger.log('Error $e');
      rethrow;
    }
  }
}
