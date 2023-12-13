import 'package:flutter/material.dart';

Text textWidget({required String? text, required TextStyle style,
TextAlign? textAlign,
TextOverflow ? textOverflow,
int? maxLines,
}) => Text(
      text ?? '',
      maxLines: maxLines,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      style: style,
      textAlign: textAlign
    );