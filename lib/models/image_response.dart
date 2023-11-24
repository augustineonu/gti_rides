import 'package:flutter/foundation.dart';

class ImageResponse {
  ImageResponse({required this.imageBytes, required this.imagePath});
  String imagePath;
  Uint8List imageBytes;
}