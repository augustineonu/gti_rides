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

  final DateRangePickerController datePickerController =
      DateRangePickerController();
  TimeOfDay? selectedStartTime = TimeOfDay.now();
  TimeOfDay? selectedEndTime = TimeOfDay.now();

  TextEditingController searchCategoryController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Rx<String> testString = "".obs;
  Rx<String> startDate = '0'.obs;
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

  RxString selectedAmPm = 'am'.obs;

  ChooseTripDateController() {
    init();
  }

  void init() {
    logger.log("ChooseTripDateController Initialized");
  }

  @override
  void onInit() async {
    final DateTime today = DateTime.now();
    startDate.value = DateFormat('dd, MMMM').format(today).toString();
    endDate.value =
        DateFormat('dd, MMMM').format(today.add(Duration(days: 3))).toString();
    datePickerController.selectedRange =
        PickerDateRange(today, today.add(Duration(days: 3)));
    update();

    super.onInit();

    // Access the arguments using Get.arguments
    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      appBarTitle.value = arguments['appBarTitle'];
      to.value = arguments['to'];
      from.value = arguments['from'];

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

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    startDate.value = formatDayDate(args.value.startDate).toString();
    endDate.value =
        formatDayDate(args.value.endDate ?? args.value.startDate).toString();
    logger.log("selected start date:: ${startDate.value}");
    logger.log("selected end date:: ${endDate.value}");
  }

  void queryListener() {}

  void goBack() => routeService.goBack();
  void goBack1() => routeService.goBack( result: {
        "start":
            "${startDate} ${selectedStartHour}:${selectedStartMinute < 10 ? '0${selectedStartMinute}' : selectedStartMinute}${selectedStartAmPm.value == 0 ? "am" : "PM"}",
        "end":
            "${endDate} ${selectedEndHour}:${selectedEndMins < 10 ? '0${selectedEndMins}' : selectedEndMins}${selectedEndAmPm.value == 0 ? "am" : "PM"}"
      });
}
