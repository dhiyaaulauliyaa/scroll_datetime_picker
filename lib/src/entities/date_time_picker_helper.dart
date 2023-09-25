part of '../scroll_date_time_picker.dart';

class _Helper {
  const _Helper(this.option);
  final DateTimePickerOption option;

  bool isAM(int hour) => hour < 12;
  int convertToHour12(int hour) => hour == 0
      ? 12
      : hour > 12
          ? hour - 12
          : hour;

  int get _numOfYear => option.maxDate.year - option.minDate.year + 1;

  int maxDay(int month, int year) {
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
        (index) => option.minDate.year + index,
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
    final normalizedRowIndex = rowIndex % itemCount(type);

    switch (type) {
      case _DateTimeType.year:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(years[normalizedRowIndex]));
      case _DateTimeType.month:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, normalizedRowIndex + 1));
      case _DateTimeType.day:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, normalizedRowIndex + 1));
      case _DateTimeType.weekday:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, normalizedRowIndex + 3));
      case _DateTimeType.hour24:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, normalizedRowIndex));
      case _DateTimeType.hour12:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, normalizedRowIndex + 1));
      case _DateTimeType.minute:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, 0, normalizedRowIndex));
      case _DateTimeType.second:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, 0, 0, normalizedRowIndex));
      case _DateTimeType.amPM:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, normalizedRowIndex == 0 ? 6 : 18));
    }
  }

  DateTime getDateFromRowIndex({
    required _DateTimeType type,
    required DateTime activeDate,
    required int rowIndex,
  }) {
    late DateTime newDate;
    final normalizedRowIndex = rowIndex % itemCount(type);

    switch (type) {
      case _DateTimeType.year:
        final newYear = years[normalizedRowIndex];

        final newMaxDay = maxDay(activeDate.month, newYear);
        var newDay = activeDate.day;
        if (newDay > newMaxDay) newDay = newMaxDay;

        newDate = activeDate.copyWith(year: newYear, day: newDay);
        break;
      case _DateTimeType.month:
        final newMonth = normalizedRowIndex + 1;

        final newMaxDay = maxDay(newMonth, activeDate.year);
        var newDay = activeDate.day;
        if (newDay > newMaxDay) newDay = newMaxDay;

        newDate = activeDate.copyWith(month: newMonth, day: newDay);
        break;
      case _DateTimeType.day:
        var newDay = normalizedRowIndex + 1;

        final newMaxDay = maxDay(activeDate.month, activeDate.year);
        if (newDay > newMaxDay) newDay = newMaxDay;

        newDate = activeDate.copyWith(day: newDay);
        break;
      case _DateTimeType.weekday:
        final oldDay = activeDate.weekday;
        final newDay = normalizedRowIndex + 1;
        final difference = newDay - oldDay;
        newDate = newDay > oldDay
            ? activeDate.add(Duration(days: difference.abs()))
            : activeDate.subtract(Duration(days: difference.abs()));
        break;
      case _DateTimeType.hour24:
        newDate = activeDate.copyWith(hour: normalizedRowIndex);
        break;
      case _DateTimeType.hour12:
        final hour = activeDate.hour;
        final newIsAM = isAM(hour);

        var newHour = normalizedRowIndex + 1 + (newIsAM ? 0 : 12);
        if (newIsAM && newHour == 12) newHour = 0;
        if (!newIsAM && newHour == 24) newHour = 12;

        newDate = activeDate.copyWith(hour: newHour);
        break;
      case _DateTimeType.minute:
        newDate = activeDate.copyWith(minute: normalizedRowIndex);
        break;
      case _DateTimeType.second:
        newDate = activeDate.copyWith(second: normalizedRowIndex);
        break;
      case _DateTimeType.amPM:
        final hour = activeDate.hour;
        final newIsAM = isAM(hour);
        var newHour = hour;

        // AM
        if (rowIndex == 0 && !newIsAM) newHour = hour - 12;

        // PM
        if (rowIndex == 1 && newIsAM) newHour = hour + 12;

        newDate = activeDate.copyWith(hour: newHour);
        break;
    }

    return newDate;
  }

  bool isTextDisabled(_DateTimeType type, DateTime activeDate, int rowIndex) {
    // Check if day is valid
    if (type == _DateTimeType.day) {
      final newMaxDay = maxDay(
        activeDate.month,
        activeDate.year,
      );
      final day = rowIndex % itemCount(type) + 1;
      if (day > newMaxDay) return true;
    }

    final date = getDateFromRowIndex(
      type: type,
      activeDate: activeDate,
      rowIndex: rowIndex,
    );

    return date.isAfter(option.maxDate) || date.isBefore(option.minDate);
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
  }) =>
      DateTime(
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
