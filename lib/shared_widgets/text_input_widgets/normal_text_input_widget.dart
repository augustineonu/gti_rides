import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/utils.dart';

class NormalInputTextWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final String expectedVariable;
  final TextInputType? textInputType;
  final Color? hintTextColor;
  final Color? fillColor;
  final bool? filled;

  final bool? readOnly;
  final String title;
  final bool? hasRichTitle;
  final String? richTitle;
  final String? richSubTitle;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? border;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final void Function()? onTap;
  final Color? textColor;
  final double? fontSize;
  final int? maxLines;
  const NormalInputTextWidget(
      {super.key,
      this.controller,
      this.labelText,
      required this.expectedVariable,
      this.textInputType,
      this.prefixIcon,
      this.hintText,
      this.hintTextColor,
      this.readOnly = false,
      this.fillColor,
      this.filled = false,
      required this.title,
      this.hasRichTitle = false,
      this.richTitle,
      this.richSubTitle,
      this.enabledBorder,
      this.focusedBorder,
      this.border,
      this.hintStyle,
      this.contentPadding,
      this.onTap,
      this.textColor,
      this.fontSize,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasRichTitle!
            ? Text.rich(
                TextSpan(
                  text: richTitle ?? '',
                  style: getRegularStyle(),
                  children: <TextSpan>[
                    TextSpan(
                        text: richSubTitle ?? '',
                        style: getRegularStyle(color: grey2)),
                    // can add more TextSpans here...
                  ],
                ),
              )
            : textWidget(text: title, style: getRegularStyle()),
        SizedBox(
          height: 3,
        ),
        TextFormField(
          controller: controller,
          keyboardType: textInputType ?? TextInputType.emailAddress,
          readOnly: readOnly!,
          onTap: onTap,
          maxLines: maxLines,
          style: getRegularStyle(fontSize: fontSize ?? 16, color: textColor),
          decoration: InputDecoration(
            filled: filled,
            fillColor: fillColor ?? Colors.transparent,
            // contentPadding: contentPadding ?? EdgeInsets.all(15),
            contentPadding: contentPadding ??
                EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
            hintText: hintText,
            hintStyle: hintStyle ??
                getLightStyle(color: grey1, fontSize: 12.sp)
                    .copyWith(fontWeight: FontWeight.w400),

            enabledBorder: enabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: grey1,
                    width: 1.0.w,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0.r),
                  ),
                ),
            focusedBorder: focusedBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: grey1,
                    width: 1.0.w,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0.r),
                  ),
                ),
            border: border ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: grey1,
                    width: 1.0.w,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0.r),
                  ),
                ),

            prefixIcon: prefixIcon,
            // const Icon(
            //   IconlyBold.moreCircle,
            //   color: secondaryColor,
            // ),
            // label: Text(
            //   labelText ?? "",
            //   style: Theme.of(context).textTheme.bodyLarge,
            // ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return fetchErrorText(expectedTextVariable: expectedVariable);
            }
            return null;
          },
        ),
      ],
    );
  }
}
