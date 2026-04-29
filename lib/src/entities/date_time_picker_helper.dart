import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';

/// A stateless utility class that provides all core computation logic for the
/// scroll datetime picker.
///
/// [DateTimePickerHelper] is intentionally kept free of Flutter widgets so that
/// its methods are easily unit-testable. It centralises three concerns:
///
/// 1. **Date arithmetic** – resolving the [DateTime] that corresponds to a
///    given scroll-wheel row index, respecting month/year boundaries and
///    12-hour ↔ 24-hour conversions.
/// 2. **Item metadata** – item counts, display text via [DateFormat], and
///    whether a particular row should be rendered as disabled.
/// 3. **Layout arithmetic** – flex-based width calculations for prefix widgets
///    that appear alongside each column.
///
/// Example construction (typically done inside a `StatefulWidget`):
/// ```dart
/// final helper = DateTimePickerHelper(option, itemFlex, prefixFlex);
/// ```
class DateTimePickerHelper {
  const DateTimePickerHelper(
    this.option,
    this.itemFlex,
    this.prefixFlex,
  );

  final DateTimePickerOption option;
  final DateTimePickerItemFlex itemFlex;
  final DateTimePickerPrefixFlex prefixFlex;

  bool isAM(int hour) => hour < 12;
  int convertToHour12(int hour) => hour == 0
      ? 12
      : hour > 12
          ? hour - 12
          : hour;

  int get numOfYear => option.maxDate.year - option.minDate.year + 1;

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
        numOfYear,
        (index) => option.minDate.year + index,
      );

  int itemCount(DateTimeType type) {
    switch (type) {
      case DateTimeType.year:
        return numOfYear;
      case DateTimeType.month:
        return 12;
      case DateTimeType.day:
        return 31;
      case DateTimeType.weekday:
        return 7;
      case DateTimeType.hour24:
        return 24;
      case DateTimeType.hour12:
        return 12;
      case DateTimeType.minute:
        return 60;
      case DateTimeType.second:
        return 60;
      case DateTimeType.amPM:
        return 2;
    }
  }

  String getText(DateTimeType type, String pattern, int rowIndex) {
    final normalizedRowIndex = rowIndex % itemCount(type);

    switch (type) {
      case DateTimeType.year:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(years[normalizedRowIndex]));
      case DateTimeType.month:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, normalizedRowIndex + 1));
      case DateTimeType.day:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, normalizedRowIndex + 1));
      case DateTimeType.weekday:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, normalizedRowIndex + 3));
      case DateTimeType.hour24:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, normalizedRowIndex));
      case DateTimeType.hour12:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, normalizedRowIndex + 1));
      case DateTimeType.minute:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, 0, normalizedRowIndex));
      case DateTimeType.second:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, 0, 0, normalizedRowIndex));
      case DateTimeType.amPM:
        return DateFormat(
          pattern,
          option.locale.languageCode,
        ).format(DateTime(2000, 1, 1, normalizedRowIndex == 0 ? 6 : 18));
    }
  }

  DateTime getDateFromRowIndex({
    required DateTimeType type,
    required DateTime activeDate,
    required int rowIndex,
  }) {
    late DateTime newDate;
    final normalizedRowIndex = rowIndex % itemCount(type);

    switch (type) {
      case DateTimeType.year:
        final newYear = years[normalizedRowIndex];

        final newMaxDay = maxDay(activeDate.month, newYear);
        var newDay = activeDate.day;
        if (newDay > newMaxDay) newDay = newMaxDay;

        newDate = activeDate.copyWith(year: newYear, day: newDay);
        break;
      case DateTimeType.month:
        final newMonth = normalizedRowIndex + 1;

        final newMaxDay = maxDay(newMonth, activeDate.year);
        var newDay = activeDate.day;
        if (newDay > newMaxDay) newDay = newMaxDay;

        newDate = activeDate.copyWith(month: newMonth, day: newDay);
        break;
      case DateTimeType.day:
        var newDay = normalizedRowIndex + 1;

        final newMaxDay = maxDay(activeDate.month, activeDate.year);
        if (newDay > newMaxDay) newDay = newMaxDay;

        newDate = activeDate.copyWith(day: newDay);
        break;
      case DateTimeType.weekday:
        final oldDay = activeDate.weekday;
        final newDay = normalizedRowIndex + 1;
        final difference = newDay - oldDay;
        newDate = newDay > oldDay
            ? activeDate.add(Duration(days: difference.abs()))
            : activeDate.subtract(Duration(days: difference.abs()));
        break;
      case DateTimeType.hour24:
        newDate = activeDate.copyWith(hour: normalizedRowIndex);
        break;
      case DateTimeType.hour12:
        final hour = activeDate.hour;
        final newIsAM = isAM(hour);

        var newHour = normalizedRowIndex + 1 + (newIsAM ? 0 : 12);
        if (newIsAM && newHour == 12) newHour = 0;
        if (!newIsAM && newHour == 24) newHour = 12;

        newDate = activeDate.copyWith(hour: newHour);
        break;
      case DateTimeType.minute:
        newDate = activeDate.copyWith(minute: normalizedRowIndex);
        break;
      case DateTimeType.second:
        newDate = activeDate.copyWith(second: normalizedRowIndex);
        break;
      case DateTimeType.amPM:
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

  bool isTextDisabled(DateTimeType type, DateTime activeDate, int rowIndex) {
    // Check if day is valid
    if (type == DateTimeType.day) {
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

  // ---------------------------------------------------------------------------
  // Layout helpers for prefix widget flex calculations
  // ---------------------------------------------------------------------------

  /// Whether [prefixWidget] has a widget defined for the given [type].
  bool hasPrefixWidget(
    DateTimeType type,
    DateTimePickerPrefixWidget prefixWidget,
  ) {
    return prefixWidget.getPrefixWidget(type) != null;
  }

  /// Returns the combined flex for a single column (item flex + prefix flex
  /// when a prefix widget exists for [type]).
  int getColumnFlex(
    DateTimeType type,
    DateTimePickerPrefixWidget prefixWidget,
  ) {
    return hasPrefixWidget(type, prefixWidget)
        ? itemFlex.getFlex(type) + prefixFlex.getFlex(type)
        : itemFlex.getFlex(type);
  }

  /// Returns the sum of all column flex values across every type present in
  /// the current date format.
  int getTotalFlex(DateTimePickerPrefixWidget prefixWidget) {
    return option.dateTimeTypes.fold(
      0,
      (sum, type) => sum + getColumnFlex(type, prefixWidget),
    );
  }

  /// Returns the pixel width that the prefix widget for [type] should occupy,
  /// given the available [containerWidth].
  double getPrefixWidth(
    DateTimeType type,
    DateTimePickerPrefixWidget prefixWidget,
    double containerWidth,
  ) {
    final total = getTotalFlex(prefixWidget);
    if (total == 0) return 0;
    return containerWidth * (prefixFlex.getFlex(type) / total);
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

extension DateTimeX on DateTime {
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