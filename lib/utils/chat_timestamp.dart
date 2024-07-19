import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget compareChatDates(String dateStr1, String dateStr2) {
  DateTime date1 = DateTime.parse(dateStr1);
  DateTime date2 = DateTime.parse(dateStr2);

  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(const Duration(days: 1));

  if (date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day) {
    return const SizedBox.shrink();
  } else if (date1.year == now.year &&
      date1.month == now.month &&
      date1.day == now.day) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text("Today"),
    );
  } else if (date1.year == yesterday.year &&
      date1.month == yesterday.month &&
      date1.day == yesterday.day) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text("Yesterday"),
    );
  } else {
    String formattedDate = DateFormat('EEE, MMM d').format(date1);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(formattedDate),
    );
  }
}
