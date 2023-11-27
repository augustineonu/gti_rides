    import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';

Widget dateTimeColWIdget({
    required String title,
    required String subTitle,
    required CrossAxisAlignment alignment,
    double? titleFontSize,
    double? subTitleFontSize,
    FontWeight? subTitleFontWeight
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        textWidget(
            text: title,
            style: getBoldStyle(
              fontSize: titleFontSize ?? 14,
            )),
        textWidget(text: subTitle, style: getRegularStyle(
          fontSize: subTitleFontSize ?? 14,

        ).copyWith(fontWeight: subTitleFontWeight ?? FontWeight.w400)),
      ],
    );
  }
