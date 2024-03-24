import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class SafeCachedNetworkImageProvider extends CachedNetworkImageProvider {

  final ImageProvider? fallbackImage;
  final int? decode;

  const SafeCachedNetworkImageProvider(String url, {this.fallbackImage, 
  this.decode}) : super(url);

  ImageStreamCompleter load(
      CachedNetworkImageProvider key, ImageDecoderCallback decode) {
    try {
      return super.loadImage(key, decode);
    } catch (e) {
      if (fallbackImage != null) {
        return fallbackImage!.loadImage(fallbackImage!, decode);
      }
      // Emit an error through the ImageStream
      final errorCompleter = ErrorImageStreamCompleter();
      errorCompleter.setError(e, StackTrace.current);
      return errorCompleter;
    }
  }
}

class ErrorImageStreamCompleter extends ImageStreamCompleter {
  void setError(Object error, StackTrace stackTrace) {
    reportError(
      context: ErrorDescription('Error in ImageStreamCompleter'),
      exception: error,
      stack: stackTrace,
    );
  }
}