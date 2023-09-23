part of '../scroll_date_time_picker.dart';

class _Helper {
  const _Helper(this.option);
  final DatePickerOption option;

  bool isAM(int hour) => hour < 12;
  int convertToHour12(int hour) => hour == 0
      ? 12
      : hour > 12
          ? hour - 12
          : hour;

  int get _numOfYear => option.getMaxDate.year - option.getMinDate.year + 1;

  int maxDate(int month, int year) {
    switch (month) {
      case 1:
        return 31;
      case 2:
        return year.isLeapYear ? 29 : 28;
      case 3:
        return 31;
      case 4:
        return 30;
      case 5:
        return 31;
      case 6:
        return 30;
      case 7:
        return 31;
      case 8:
        return 31;
      case 9:
        return 30;
      case 10:
        return 31;
      case 11:
        return 30;
      case 12:
        return 31;

      default:
        return 0;
    }
  }

  List<int> get years => List.generate(
        _numOfYear,
        (index) => option.getMinDate.year - 1 + index,
      );

  int itemCount(_DateTimeType type) {
    switch (type) {
      case _DateTimeType.year:
        return _numOfYear;
      case _DateTimeType.month:
        return 12;
      case _DateTimeType.day:
        return 31;
      case _DateTimeType.weekday:
        return 7;
      case _DateTimeType.hour24:
        return 24;
      case _DateTimeType.hour12:
        return 12;
      case _DateTimeType.minute:
        return 60;
      case _DateTimeType.second:
        return 60;
      case _DateTimeType.amPM:
        return 2;
    }
  }

  String getText(_DateTimeType type, String pattern, int rowIndex) {
    switch (type) {
      case _DateTimeType.year:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(years[rowIndex]));
      case _DateTimeType.month:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, rowIndex + 1));
      case _DateTimeType.day:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, rowIndex + 1));
      case _DateTimeType.weekday:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, rowIndex + 3));
      case _DateTimeType.hour24:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, rowIndex));
      case _DateTimeType.hour12:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, rowIndex + 1));
      case _DateTimeType.minute:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, 0, rowIndex));
      case _DateTimeType.second:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, 0, 0, rowIndex));
      case _DateTimeType.amPM:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, rowIndex == 0 ? 6 : 18));
    }
  }
}

extension LeapYearX on int {
  bool get isLeapYear {
    if (this % 4 == 0) {
      if (this % 100 == 0) {
        if (this % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}

extension _DateTimeX on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
