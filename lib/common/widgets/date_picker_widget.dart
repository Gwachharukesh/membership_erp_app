import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAndTimePicker {
  static Future<DateTime?> showCustomDatePicker(
    BuildContext context, {
    DateTime? lastDate,
    DateTime? firstDate,
  }) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
    );
  }
}

extension DateTimeFormat on DateTime {
  String format() => DateFormat('yyyy-MM-dd').format(this);
}
