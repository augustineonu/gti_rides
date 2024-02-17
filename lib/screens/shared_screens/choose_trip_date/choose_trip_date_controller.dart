import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/shared_widgets/text_widget.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChooseTripDateController extends GetxController {
  Logger logger = Logger("Controller");
  RxBool isLoading = false.obs;
  RxBool isSingleDateSelection = false.obs;
  RxBool enablePastDates = true.obs;
  RxBool toggleDaySelection = true.obs;
  RxBool onCancelCalled = false.obs;
  RxBool isRenterHome = false.obs;

  final DateRangePickerController datePickerController =
      DateRangePickerController();
  TimeOfDay? selectedStartTime = TimeOfDay.now();
  TimeOfDay? selectedEndTime = TimeOfDay.now();

  TextEditingController searchCategoryController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Rx<String> testString = "".obs;
  Rx<String> startDate = '0'.obs;
  Rx<String?> selectedExpiryDate = ''.obs;
  Rx<String> endDate = '0'.obs;
  Rx<String> selectedTimeText = ''.obs;
  RxInt selectedStartHour = 0.obs;
  RxInt selectedEndHour = 0.obs;
  RxInt selectedStartMinute = 0.obs;
  RxInt selectedEndMins = 0.obs;
  RxInt selectedStartAmPm = 0.obs;
  RxInt selectedEndAmPm = 0.obs;
  RxString appBarTitle = ''.obs;
  RxString to = ''.obs;
  RxString from = ''.obs;
  Rx<int> selectedDifferenceInDays = 0.obs;

  RxString selectedAmPm = 'am'.obs;
  DateTime? rawStartTime;
  DateTime? rawEndTime;

  ChooseTripDateController() {
    init();
  }

  void init() {
    logger.log("ChooseTripDateController Initialized");
  }

  @override
  void onInit() async {
    final DateTime today = DateTime.now();
    // startDate.value = DateFormat('dd, MMMM').format(today).toString();
    startDate.value = formatDayDate(today).toString();
    endDate.value = formatDayDate(today.add(Duration(days: 3))).toString();
    
    rawStartTime = today;
    rawEndTime = today.add(Duration(days: 3));
    // endDate.value =
    // DateFormat('dd, MMMM').format(today.add(Duration(days: 3))).toString();
    datePickerController.selectedRange =
        PickerDateRange(today, today.add(Duration(days: 3)));

    selectedDifferenceInDays.value = 3;
    update();

    super.onInit();

    // Access the arguments using Get.arguments
    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      appBarTitle.value = arguments['appBarTitle'] ?? "";
      to.value = arguments['to'] ?? '';
      from.value = arguments['from'] ?? '';
      isSingleDateSelection.value = arguments['isSingleDateSelection'] ?? false;
      enablePastDates.value = arguments['enablePastDates'] ?? true;
      isRenterHome.value = arguments['isRenterHome'] ?? false;
      // startDate.value = arguments['startDate'] ?? '';
      logger.log("date ${arguments['enablePastDates']}");
      logger.log("date ${enablePastDates.value}");

      // Now you have access to the passed data (emailOrPhone)
      logger.log('Received argument: $appBarTitle');
    }
  }

  void onSelectedStartHourChanged(int value) => selectedStartHour.value = value;

  void onSelectedStartMinsChanged(int value) =>
      selectedStartMinute.value = value;

  void onSelectedStartAmPmChanged(int value) => selectedStartAmPm.value = value;

  void onSelectedEndHourChanged(int value) => selectedEndHour.value = value;
  void onSelectedEndMinsChanged(int value) => selectedEndMins.value = value;
  void onSelectedEndAmPmChanged(int value) => selectedEndAmPm.value = value;

  void updateSelectedTime(
      int selectedStartHour, int selectedMinute, String selectedAmPm) {
    final formattedHour = selectedAmPm == 'am' && selectedStartHour == 12
        ? 0
        : selectedAmPm == 'pm' && selectedStartHour != 12
            ? selectedStartHour + 12
            : selectedStartHour;

    final formattedMinute = selectedMinute;
    selectedTimeText.value =
        '$formattedHour:${formattedMinute.toString().padLeft(2, '0')}$selectedAmPm';
  }

  PickerDateRange? selectedDateRange;

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    startDate.value = formatDayDate(args.value.startDate).toString();
    rawStartTime = args.value.startDate;
    rawEndTime = args.value.endDate;
    update();

    logger.log("Raw start date: ${args.value.startDate}");
    endDate.value =
        formatDayDate(args.value.endDate ?? args.value.startDate).toString();
    logger.log("selected start date:: ${startDate.value}");
    logger.log("selected end date:: ${endDate.value}");

    if (args.value is PickerDateRange) {
      selectedDateRange = args.value as PickerDateRange?;
      print('Selected Range: ${selectedDateRange}');

      if (selectedDateRange?.startDate != null &&
          selectedDateRange?.endDate != null) {
        // Calculate the difference
        Duration difference = calculateDateDifference(
            selectedDateRange!.startDate!,
            selectedDateRange!.endDate ?? selectedDateRange!.startDate!);

        selectedDifferenceInDays.value = difference.inDays;

        print('Difference in days: ${difference.inDays}');
      }
    }
  }

  Duration calculateDateDifference(DateTime startDate, DateTime endDate) {
    // Calculate the difference between two dates
    return endDate.difference(startDate);
  }

  void addRawTime() {
    rawStartTime = addHoursAndMinutes(
        dateTime: rawStartTime!,
        hours: selectedStartHour.value,
        minutes: selectedStartMinute.value,
        isAM: selectedStartAmPm.value == 0 ? true : false);

    rawEndTime = addHoursAndMinutes(
        dateTime: rawEndTime!,
        hours: selectedEndHour.value,
        minutes: selectedEndMins.value,
        isAM: selectedEndAmPm.value == 0 ? true : false);
        logger.log("Raw start time:: $rawStartTime");
        logger.log("Raw end time:: $rawEndTime");
   goBack1();
  }

  void onSingleDateSelection(DateRangePickerSelectionChangedArgs args) {
    if (args.value != null && args.value != '') {
      selectedExpiryDate.value = formatDate(args.value!).toString();

      logger.log("Selected args: ${args.value}");
      logger.log("Selected date: ${selectedExpiryDate.value}");
    } else {
      // Handle the case when the date is unselected (null)
      selectedExpiryDate.value = ''; // Or any default value you want
      logger.log("Date unselected");
    }
  }

  void resetDateSelection(context) {
    toggleDaySelection.value = true;
    onCancelCalled.value = true;
    bottomSnackbar(context, message: 'Selection cleared');
    // selectedExpiryDate.value = '';
  }

  void queryListener() {}

  // void goBack() => routeService.goBack();
  // void goBack1({bool? closeOverlays = true}) => routeService.goBack(result: {
  //       "start":
  //           "$startDate $selectedStartHour:${selectedStartMinute < 10 ? '0$selectedStartMinute' : selectedStartMinute}${selectedStartAmPm.value == 0 ? "am" : "PM"}",
  //       "end":
  //           "$endDate $selectedEndHour:${selectedEndMins < 10 ? '0$selectedEndMins' : selectedEndMins}${selectedEndAmPm.value == 0 ? "am" : "PM"}",
  //       "selectedExpiryDate": selectedExpiryDate.value,
  //     }, closeOverlays: !isRenterHome.value ? false : closeOverlays);

  void goBack1({bool? closeOverlays = true}) {
    Map<String, dynamic> result = {
      "start":
          "$startDate $selectedStartHour:${selectedStartMinute < 10 ? '0$selectedStartMinute' : selectedStartMinute}${selectedStartAmPm.value == 0 ? "am" : "PM"}",
      "end":
          "$endDate $selectedEndHour:${selectedEndMins < 10 ? '0$selectedEndMins' : selectedEndMins}${selectedEndAmPm.value == 0 ? "am" : "PM"}",
      "selectedExpiryDate": selectedExpiryDate.value,
      "differenceInDays": selectedDifferenceInDays.value,
      "rawStartTime": rawStartTime,
      "rawEndTime": rawEndTime
    };

    // Check if any of the values in the result map is null, and provide default values if so
    result.forEach((key, value) {
      if (value == null) {
        result[key] = ''; // Provide an empty string as the default value
      }
    });

    routeService.goBack(
        result: result,
        closeOverlays: !isRenterHome.value ? false : closeOverlays);
  }

  void goBack2() {
    Map<String, dynamic> result = {
      "start":
          "$startDate $selectedStartHour:${selectedStartMinute < 10 ? '0$selectedStartMinute' : selectedStartMinute}${selectedStartAmPm.value == 0 ? "am" : "PM"}",
      "end":
          "$endDate $selectedEndHour:${selectedEndMins < 10 ? '0$selectedEndMins' : selectedEndMins}${selectedEndAmPm.value == 0 ? "am" : "PM"}",
      "selectedExpiryDate": selectedExpiryDate.value,
      "differenceInDays": selectedDifferenceInDays.value
    };

    // Check if any of the values in the result map is null, and provide default values if so
    result.forEach((key, value) {
      if (value == null) {
        result[key] = ''; // Provide an empty string as the default value
      }
    });

    routeService.goBack(
      result: result,
    );
  }
}
