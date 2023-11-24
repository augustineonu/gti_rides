import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/styles.dart';

class GtiButton extends StatelessWidget {
  final void Function()? onTap;
  final Color color;
  final Color disabledColor;
  final Color? textColor;
  final String? text;
  final bool? isLoading;
  final bool hasIcon;
  final double? hasIconSpace;
  final bool hasSuffixIcon;
  final Widget? iconWidget;
  final Widget? suffixIconWidget;
  final bool isSmall;
  final bool hasBorder;
  final bool isDisabled;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? borderColor;
  final double? borderRadius;
  final TextStyle? style;
  const GtiButton(
      {Key? key,
      this.onTap,
      this.color =  primaryColor,
      this.disabledColor = const Color(0xff828282),
      this.textColor,
      this.text,
      this.isLoading = false,
      this.hasIcon = false,
      this.hasSuffixIcon = false,
      this.iconWidget,
      this.suffixIconWidget,
      this.isSmall = false,
      this.hasBorder = false,
      this.isDisabled = false,
      this.height = 40,
      this.width = 250,
      this.borderColor,
      this.borderRadius,
      this.style,
      this.fontSize,
      this.hasIconSpace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => HapticFeedback.lightImpact(),
      onTap: isDisabled ? null : () => onTap!(),
      child: Container(
        height: height,
        width: isSmall ? 150 : width,
        decoration: BoxDecoration(
          // color: isLoading! ? color.withOpacity(.5) : color,
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
          color: isDisabled
              ? disabledColor
              : isLoading!
                  ? color
                  : color,
          border: hasBorder
              ? Border.all(color: borderColor!)
              : Border.all(width: 0, color: color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hasIcon ? iconWidget! : SizedBox.shrink(),
            hasIcon
                ? SizedBox(
                    width: hasIconSpace ?? 15,
                  )
                : SizedBox.shrink(),
            Center(
              child: Text(isLoading! ? "" : text ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: style ??
                      getBoldStyle(
                          color:
                              isDisabled ? disabledColor : textColor ?? white,
                          fontSize: fontSize ?? 16,
                          fontWeight: FontWeight.w600)),
            ),
            hasSuffixIcon ? suffixIconWidget! : SizedBox.shrink(),
            hasSuffixIcon
                ? SizedBox(
                    width: 15,
                  )
                : SizedBox.shrink(),
            const SizedBox(
              height: 24,
            ),
            isLoading!
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
