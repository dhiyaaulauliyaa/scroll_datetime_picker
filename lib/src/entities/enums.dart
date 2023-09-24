part of '../date_picker/scroll_date_picker.dart';

enum _DateTimeType {
  year('year'),
  month('month'),
  day('day'),
  weekday('weekday'),
  hour24('hour'),
  hour12('hour24'),
  minute('minute'),
  second('second'),
  amPM('amPM');

  const _DateTimeType(this.name);
  final String name;

  String get basePattern {
    switch (this) {
      case year:
        return 'y';
      case month:
        return 'M';
      case day:
        return 'd';
      case weekday:
        return 'E';
      case hour24:
        return 'H';
      case hour12:
        return 'h';
      case minute:
        return 'm';
      case second:
        return 's';
      case amPM:
        return 'a';
    }
  }

  static _DateTimeType fromPattern(String pattern) {
    final firstChar = pattern[0];

    if (year.basePattern == firstChar) return year;
    if (month.basePattern == firstChar) return month;
    if (day.basePattern == firstChar) return day;
    if (weekday.basePattern == firstChar) return weekday;
    if (hour24.basePattern == firstChar) return hour24;
    if (hour12.basePattern == firstChar) return hour12;
    if (minute.basePattern == firstChar) return minute;
    if (second.basePattern == firstChar) return second;
    if (amPM.basePattern == firstChar) return amPM;

    // Special cases
    if (pattern == 'j') return hour12;
    if (pattern == 'c') return day;
    if (pattern == 'cc') return day;
    if (pattern == 'ccc') return weekday;
    if (pattern == 'cccc') return weekday;

    throw Exception('DateFormat is not valid: $pattern');
  }
}
