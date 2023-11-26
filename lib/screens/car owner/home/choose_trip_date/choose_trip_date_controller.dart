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
  Rx<String> testString = "Hello".obs;
  Rx<String> startDate = '0'.obs;
  Rx<String> endDate = '0'.obs;
  Rx<String> selectedTimeText = ''.obs;
  RxInt selectedHour = 0.obs;
  RxInt selectedMinute = 0.obs;
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
  }

  void updateSelectedTime(
      int selectedHour, int selectedMinute, String selectedAmPm) {
    final formattedHour = selectedAmPm == 'am' && selectedHour == 12
        ? 0
        : selectedAmPm == 'pm' && selectedHour != 12
            ? selectedHour + 12
            : selectedHour;

    final formattedMinute = selectedMinute;
    selectedTimeText.value =
        '$formattedHour:${formattedMinute.toString().padLeft(2, '0')}$selectedAmPm';
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    startDate.value = formatDate(args.value.startDate).toString();
    endDate.value =
        formatDate(args.value.endDate ?? args.value.startDate).toString();
  }

  void queryListener() {}

  void goBack() => routeService.goBack();
}
