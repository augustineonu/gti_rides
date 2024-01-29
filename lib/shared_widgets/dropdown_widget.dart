import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/constants.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:iconsax/iconsax.dart';

Widget dropdownWidget({
  required BuildContext context,
  // required Map<String, dynamic>? selectedUserValue,
  required String? hintText,
  required List<Map<String, dynamic>> values,
  required Function onChange,
  InputDecoration? decoration,
  required String title,
  Color? iconColor,
  void Function()? onTap,
  String? expectedVariable,
  Map<String, dynamic>? selectedValue,
}) {

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      textWidget(
        text: title,
        style: getRegularStyle(fontSize: 14.sp),
      ),
      SizedBox(
        height: 5.sp,
      ),
      SizedBox(
        child: GestureDetector(
          onTap: onTap,
          child: Material(
            borderOnForeground: false,
            color: Colors.transparent,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<Map<String, dynamic>>(
                isExpanded: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return fetchErrorText(
                        expectedTextVariable: expectedVariable ?? '');
                  }
                  return null;
                },
                value: selectedValue,
                hint: Text(
                  hintText!,
                  style: getRegularStyle(color: borderColor),
                ),
                // value: selectedUserValue,
                selectedItemBuilder: (context) {
                  return values
                      .map((item) => Container(
                            alignment: Alignment.centerLeft,
                            constraints: const BoxConstraints(minWidth: 100),
                            child: Text(
                              item['name'] ?? '',
                              // selectedValue?['name'] ?? 'no bank',
                              style: getRegularStyle(),
                            ),
                          ))
                      .toList();
                },
                items: [...values, if (selectedValue != null) selectedValue!].map((item) {
                  bool isSelected = item == selectedValue;
                  return DropdownMenuItem(
                    value: item,
                    child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] ?? '',
                            style: getRegularStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            item['details'] ?? '',
                            style: getRegularStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
                onChanged: (Map<String, dynamic>? value) {
                  onChange(value);
                },
                icon: const Icon(
                  Iconsax.arrow_down_1,
                  color: borderColor,
                ),
                decoration: decoration ??
                    InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 5.sp, vertical: 13.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: borderColor,
                          width: 1.0.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0.r),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: borderColor,
                          width: 1.0.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0.r),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secondaryColor,
                          width: 1.0.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0.r),
                        ),
                      ),

                      // filled: true,
                      fillColor: Colors.transparent,
                    ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget dropdownWidget1({
  required BuildContext context,
  // required String? selectedUserValue,
  required String? hintText,
  required List<String> values,
  required Function onChange,
  String? selectedValue,
  InputDecoration? decoration,
  required String? title,
  Color? iconColor,
  void Function()? onTap,
  String? expectedVariable,
  bool multipleSelection = false,
  void Function(String?)? onSaved,

  Key? key,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      textWidget(
        text: title,
        textOverflow: TextOverflow.visible,
        style: getRegularStyle(fontSize: 12.sp),
      ),
      SizedBox(
        height: 5.sp,
      ),
      SizedBox(
        // height: 55.sp,
        // padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: GestureDetector(
          onTap: onTap,
          child: Material(
            borderOnForeground: false,
            color: Colors.transparent,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField(
                iconEnabledColor: red,
                isExpanded: true,
                onSaved: onSaved,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return fetchErrorText(
                        expectedTextVariable: expectedVariable ?? '');
                  }
                  return null;
                },
                hint: Text(
                  hintText!,
                  style: getRegularStyle(color: borderColor),
                ),
                value: selectedValue,
                selectedItemBuilder: (context) {
                  return values
                      .map((item) => Container(
                            alignment: Alignment.centerLeft,
                            constraints: const BoxConstraints(minWidth: 100),
                            child: Text(
                              item,
                              style: getRegularStyle(),
                            ),
                          ))
                      .toList();
                },
                items: values
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        onTap: (){
                          print("Hello world");
                        },
                        child: multipleSelection
                            ? Row(
                                children: [
                                  Checkbox(
                                    onChanged: (value) {},
                                    value: false,
                                  ),
                                  Text(
                                    item,
                                    style: getRegularStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                item,
                                style: getRegularStyle(
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    )
                    .toList(),
                key: key,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
                // onTap: onTap,
                onChanged: (String? value) => onChange(value),
                icon: Icon(
                  Iconsax.arrow_down_1,
                  color: iconColor ?? borderColor,
                ),
                decoration: decoration ??
                    InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 5.sp, vertical: 13.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: borderColor,
                          width: 1.0.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0.r),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: red,
                          width: 1.0.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0.r),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: borderColor,
                          width: 1.0.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0.r),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secondaryColor,
                          width: 1.0.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0.r),
                        ),
                      ),

                      // filled: true,
                      fillColor: Colors.transparent,
                    ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget multiDropdownWidget({
  required BuildContext context,
  // required String? selectedUserValue,
  required String? hintText,
  required List<String> values,
  required Function onChange,
  String? selectedValue,
  InputDecoration? decoration,
  required String? title,
  Color? iconColor,
  void Function()? onTap,
  String? expectedVariable,
  bool multipleSelection = false,
  Key? key,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      textWidget(
        text: title,
        style: getRegularStyle(fontSize: 12.sp),
      ),
      SizedBox(
        height: 5.sp,
      ),
      SizedBox(
        // height: 55.sp,
        // padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: GestureDetector(
          onTap: onTap,
          child: Material(
            borderOnForeground: false,
            color: Colors.transparent,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonHideUnderline(
                key: key,
                child: DropdownButton2(
                  hint: textWidget(text: 'Select', style: getRegularStyle()),
                  value: selectedValue,
                  onChanged: (String? value) => onChange(value),
                  selectedItemBuilder: (context) {
                    return values
                        .map((item) => Container(
                              alignment: Alignment.centerLeft,
                              constraints: const BoxConstraints(minWidth: 100),
                              child: Text(
                                item,
                                style: getRegularStyle(),
                              ),
                            ))
                        .toList();
                  },
                  items: values
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                                  item,
                                  style: getRegularStyle(
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class DropDownMenuWidget extends StatelessWidget {
  DropDownMenuWidget({
    super.key,
    required this.selectedUserValue,
    required this.hintText,
    required this.values,
    required this.onChange,
    this.radius = 5,
    this.arrow = Colors.white,
    this.display = Colors.white,
    this.displayWeight = FontWeight.w600,
    this.displaySize = 16,
  });

  final String? selectedUserValue;
  final String? hintText;
  final Map<String, String> values;
  final Function onChange;
  double? radius;
  Color arrow;
  Color display;
  FontWeight displayWeight;
  double displaySize;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderOnForeground: false,
      color: Colors.transparent,
      child: DropdownButtonFormField(
        hint: Text(
          hintText!,
          style: TextStyle(
            fontSize: displaySize,
            color: display,
            fontWeight: displayWeight,
          ),
        ),
        value: selectedUserValue,
        selectedItemBuilder: (context) {
          return values.values
              .map((item) => Container(
                    alignment: Alignment.centerLeft,
                    constraints: const BoxConstraints(minWidth: 100),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: displaySize,
                        color: display,
                        fontWeight: displayWeight,
                      ),
                    ),
                  ))
              .toList();
        },
        items: values.keys
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            )
            .toList(),
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.white),
        onChanged: (String? value) => onChange(value),
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: arrow,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(5.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(5.r),
          ),
          focusColor: Colors.black,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(5.r),
          ),
          // filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}

Widget mYDropdown(BuildContext context,
    {required List<String> values, required Function onChange, String? value}) {
  return Center(
    child: DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          'Select Item',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: values
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        value: value,
        onChanged: (String? value) => onChange(value),
        // });

        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    ),
  );
}
