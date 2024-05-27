import 'package:intl/intl.dart';

String formattedFlightDate(DateTime date) {
  return DateFormat('E, MMM d yyyy').format(date);
}

String formattedSearchDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatTimezone(String time, String timezone, bool includeTimezone) {
  DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
  if (timezone == 'WITA') {
    parsedTime = parsedTime.add(const Duration(hours: 1));
  } else if (timezone == 'WIT') {
    parsedTime = parsedTime.add(const Duration(hours: 2));
  } else if (timezone == 'GMT') {
    parsedTime = parsedTime.subtract(const Duration(hours: 7));
  }
  String formattedTime = DateFormat('HH.mm').format(parsedTime);
  if (includeTimezone) {
    return '$formattedTime $timezone';
  }
  return formattedTime;
}

Map<String, String> flightDuration(String date, String time1, String timezone1,
    String time2, String timezone2, bool includeTimezone) {
  String note = '';
  DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
  DateTime parsedTime1 = DateFormat('HH:mm:ss').parse(time1);
  DateTime parsedTime2 = DateFormat('HH:mm:ss').parse(time2);
  if (parsedTime2.isBefore(parsedTime1)) {
    String temp = DateFormat('yyyy-MM-dd')
        .format(parsedDate.add(const Duration(days: 1)));
    parsedTime2 = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$temp $time2');
  } else {
    parsedTime2 = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date $time2');
  }
  parsedTime1 = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date $time1');

  Duration duration = parsedTime2.difference(parsedTime1);
  DateTime temp1 = changeTimezone(parsedTime1, timezone1);
  DateTime temp2 = changeTimezone(parsedTime2, timezone2);
  if (temp2.isAfter(temp1)) {
    note = '(+1d)';
  } else if (temp2.isBefore(temp1)) {
    note = '(-1d)';
  }
  String formattedDuration = formatDuration(duration);
  return {
    'duration': formattedDuration,
    'note': note,
    'departure_time': formatTimezone(time1, timezone1, includeTimezone),
    'arrival_time': formatTimezone(time2, timezone2, includeTimezone),
    'departure_date': formattedFlightDate(temp1),
    'arrival_date': formattedFlightDate(temp2),
  };
}

DateTime changeTimezone(DateTime dateTime, String timezone) {
  if (timezone == 'WITA') {
    dateTime = dateTime.add(const Duration(hours: 1));
  } else if (timezone == 'WIT') {
    dateTime = dateTime.add(const Duration(hours: 2));
  } else if (timezone == 'GMT') {
    dateTime = dateTime.subtract(const Duration(hours: 7));
  }
  dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
  return dateTime;
}

String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  String formattedString = '${hours}h ${minutes}m';
  return formattedString;
}

DateTime parseDate(String date) {
  return DateFormat('yyyy-MM-dd').parse(date);
}

DateTime parseArrivalTime(String date, String time1, String time2) {
  DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
  DateTime parsedTime1 = DateFormat('HH:mm:ss').parse(time1);
  DateTime parsedTime2 = DateFormat('HH:mm:ss').parse(time2);
  if (parsedTime2.isBefore(parsedTime1)) {
    String temp = DateFormat('yyyy-MM-dd')
        .format(parsedDate.add(const Duration(days: 1)));
    parsedTime2 = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$temp $time2');
  } else {
    parsedTime2 = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date $time2');
  }
  return parsedTime2.toUtc().add(const Duration(hours: 7));
}
