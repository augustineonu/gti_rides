import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const primaryColor = Color(0xffECAE00);
const primaryColorLight = Color(0xffFFD970);
const primaryColorVeryLight = Color(0xffF9d7a3);
const primaryColorLight1 = Color(0xffFFF7E2);
const primaryColorLight2 = Color(0xfffdf7e2);
const primaryColorLight3 = Color(0xfffdf6de);
const primaryColorDark = Color(0xff1A1300);
const backgroundColor = Color(0xffFFFBF0);
const secondaryColor = Color(0xff1A1300);
const white = Color(0xFFFFFFFF);
const darkBrown = Color(0xff1a1300);
const success = Color(0xFF48cfad);
const danger = Color(0xFFFF000D);
const shadowColor = Color(0X95E9EBF0);
const disabledColor1 = Color(0x07675750);
const black = Color(0xFF000000);
const red = Color(0xffBB0000);
const green = Color(0xff02C20F);
const scaffoldColor = Color(0xffF7F8FD);
const greyLight = Color(0xffD4D4D4);
const greyLight1 = Color(0xffF2F2F2);
const grey1 = Color(0xffADADAD);
const grey2 = Color(0xff858585);
const grey3 = Color(0xff5C5C5C);
const grey4 = Color(0xff333333);
const grey5 = Color(0xff0A0A0A);
const greyShade = Color(0xff333333);
const greyShade1 = Color(0xff5E6368);
const borderColor = Color(0xffD4D4D4);
const yellow = Colors.yellow;

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color bgColor = white,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow
        ? [const BoxShadow(color: shadowColor, blurRadius: 2, spreadRadius: 2)]
        : [const BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

// Text styles
TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: 'Basis Grotesque Pro',
    fontWeight: fontWeight,
    color: color,
  );
}

// regular style
TextStyle getRegularStyle({double fontSize = 14.0, Color? color}) {
  return _getTextStyle(
    fontSize,
    FontWeight.w400,
    color ?? textColor(),
  );
}

// light text style
TextStyle getLightStyle({double fontSize = 14.0, Color? color}) {
  return _getTextStyle(
    fontSize,
    FontWeight.w300,
    color ?? textColor(),
  );
}

// bold text style
TextStyle getBoldStyle(
    {double fontSize = 14.0, Color? color, FontWeight? fontWeight}) {
  return _getTextStyle(
    fontSize,
    fontWeight ?? FontWeight.w700,
    color ?? textColor(),
  );
}

// semiBold style
TextStyle getSemiBoldStyle({double fontSize = 14.0, Color? color}) {
  return _getTextStyle(
    fontSize,
    FontWeight.w600,
    color ?? textColor(),
  );
}

// extrabold text style
TextStyle getExtraBoldStyle({double fontSize = 14.0, Color? color}) {
  return _getTextStyle(
    fontSize,
    FontWeight.w800,
    color ?? textColor(),
  );
}

// medium text style
TextStyle getMediumStyle({double fontSize = 14.0, Color? color}) {
  return _getTextStyle(
    fontSize.sp,
    FontWeight.w500,
    color ?? textColor(),
  );
}

// colors
Color textColor() {
  return secondaryColor;
}

Color textColorGrey() {
  return grey2;
}

Color iconColor() {
  return secondaryColor;
}

Color appColors() {
  return primaryColor;
}

Color scaffold() {
  return scaffoldColor;
}

Color shimmerBaseColor() {
  return Colors.grey.shade300;
}

Color shimmerHighlightColor() {
  return Colors.grey.shade100;
}

Color shadowColor1() {
  return grey1.withOpacity(0.3);
}

// Form decoration
InputDecoration inputDecoration(
    {String? hintText,
    Widget? suffixIcon,
    Color? fillColor,
    Color? borderColor}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(10),
    hintText: hintText,
    errorStyle: const TextStyle(fontSize: 0),
    errorMaxLines: 1,
    filled: true,
    fillColor: fillColor ?? (const Color(0xffF9FAFB)),
    hintStyle: getRegularStyle(color: shadowColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: borderColor ?? (const Color(0xffD0D5DD)),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: borderColor ?? const Color(0xffD0D5DD),
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: borderColor ?? const Color(0xffD0D5DD),
        width: 1,
      ),
    ),
    suffixIcon: suffixIcon,
    suffixIconColor: iconColor(),
  );
}
