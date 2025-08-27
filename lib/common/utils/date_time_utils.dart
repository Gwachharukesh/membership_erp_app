import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:membership_erp_app/common/extension/extensions.dart';
import 'package:nepali_utils/nepali_utils.dart';

class DateTimeUtils {
  static DateTime getFiscalYear() {
    NepaliDateTime currentDate = NepaliDateTime.now();

    return (currentDate.isBefore(NepaliDateTime(currentDate.year, 4))
            ? NepaliDateTime(currentDate.year - 1, 4)
            : NepaliDateTime(currentDate.year, 4))
        .toDateTime();
  }

  static String formatDateTimeString(
    String date, {
    bool isNepali = false,
    String pattern = 'dd-MMMM-yyyy',
  }) {
    if (date.isNotEmpty) {
      if (isNepali) {
        return NepaliDateFormat(
          pattern,
        ).format(date.toDateTime()!.toNepaliDateTime());
      }
      return DateFormat(pattern).format(DateTime.parse(date));
    }
    return '';
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isTokenExpired(String tokenExpiryDate) {
    try {
      final format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");

      // Parse as UTC
      DateTime expiryUtc = format.parse(tokenExpiryDate, true);

      // Convert to local timezone (device's timeezone: NPT in your case)
      DateTime expiryLocal = expiryUtc.toLocal();

      DateTime now = DateTime.now(); // Already local
      log('Expired :$expiryLocal');
      log('Now: $now');
      log('Is Expired: ${expiryLocal.isBefore(now)}');
      return expiryLocal.isBefore(now);
    } catch (e) {
      log("Error processing token expiry date: $e");
      return true;
    }
  }
}
