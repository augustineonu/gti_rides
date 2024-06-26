import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/utils.dart';

class PasswordInputTextWidget extends StatelessWidget {
  final theme;
  final TextEditingController controller;
  final bool? isObscureValue;
  final VoidCallback? onTap;
  final String expectedVariable;
  final IconData? icon;
  final String title;
  final InputBorder? errorBorder;
  final String? Function(String?)? validator;
  const PasswordInputTextWidget(
      {super.key,
      this.theme,
      this.isObscureValue,
      required this.controller,
      required this.expectedVariable,
      this.onTap,
      this.icon,
      required this.title,
      this.errorBorder,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: title, style: getRegularStyle()),
        TextFormField(
            controller: controller,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'\S'))],
            // style: theme.bodyText1.copyWith(fontSize: 16.0),
            style: getRegularStyle(fontSize: 16),
            obscureText: isObscureValue ?? false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              errorMaxLines: 3,
              // prefixIcon: const Icon(
              //   Iconsax.lock,
              //   color: secondaryColor,
              // ),
              hintText: "*********",
              hintStyle: const TextStyle(color: grey1),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: grey1,
                  width: 1.0.w,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0.r),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 1.0.w,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0.r),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: grey1,
                  width: 1.0.w,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0.r),
                ),
              ),
              errorBorder: errorBorder ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: danger,
                      width: 1.0.w,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0.r),
                    ),
                  ),
              // label: Text(
              //   'Password ',
              //   // style: theme.bodyText1,
              // ),
              suffixIcon: IconButton(
                icon: SvgPicture.asset(
                  ImageAssets.eye,
                  height: 12.sp,
                  color: primaryColor,
                ),
                onPressed: onTap ?? () {},
              ),
            ),
            validator: validator ??
                (value) {
                  if (value!.isEmpty) {
                    return fetchErrorText(
                        expectedTextVariable: expectedVariable);
                  }
                  return null;
                }),
      ],
    );
  }
}
