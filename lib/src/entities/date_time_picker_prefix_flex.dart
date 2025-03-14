part of '../scroll_date_time_picker.dart';

/// Class to specify the flex width (proportional space) for different prefix
/// items in a datetime picker.
///
/// This class provides a way to customize the width allocation for each prefix item in
/// a datetime picker. By adjusting the flex values for each date/time prefix item, you can
/// control the visual spacing and layout of the datetime picker prefix items.
class DateTimePickerPrefixFlex {
  /// Creates an instance of [DateTimePickerPrefixFlex].
  ///
  /// All parameters are optional and default to 1.
  ///
  /// - [yearFlex]: The flex width for the year prefix item.
  /// - [monthFlex]: The flex width for the month prefix item.
  /// - [dayFlex]: The flex width for the day prefix item.
  /// - [weekdayFlex]: The flex width for the weekday prefix item.
  /// - [hour24Flex]: The flex width for the 24-hour format hour prefix item.
  /// - [hour12Flex]: The flex width for the 12-hour format hour prefix item.
  /// - [minuteFlex]: The flex width for the minute prefix item.
  /// - [secondFlex]: The flex width for the second prefix item.
  /// - [amPMFlex]: The flex width for the AM/PM prefix item.
  const DateTimePickerPrefixFlex({
    this.yearFlex = 1,
    this.monthFlex = 1,
    this.dayFlex = 1,
    this.weekdayFlex = 1,
    this.hour24Flex = 1,
    this.hour12Flex = 1,
    this.minuteFlex = 1,
    this.secondFlex = 1,
    this.amPMFlex = 1,
  });

  /// The flex width for the year prefix item.
  final int yearFlex;

  /// The flex width for the month prefix item.
  final int monthFlex;

  /// The flex width for the day prefix item.
  final int dayFlex;

  /// The flex width for the weekday prefix item.
  final int weekdayFlex;

  /// The flex width for the 24-hour format hour prefix item.
  final int hour24Flex;

  /// The flex width for the 12-hour format hour prefix item.
  final int hour12Flex;

  /// The flex width for the minute prefix item.
  final int minuteFlex;

  /// The flex width for the second prefix item.
  final int secondFlex;

  /// The flex width for the AM/PM prefix item.
  final int amPMFlex;
}

/// Extension to retrieve the flex width for a specific [DateTimeType].
extension DateTimePickerPrefixFlexX on DateTimePickerPrefixFlex {
  /// Retrieves the flex width for a specific [DateTimeType].
  ///
  /// - [type]: The date or time type for which to get the flex width.
  /// - Returns the flex width as an integer.
  int getFlex(DateTimeType type) {
    switch (type) {
      case DateTimeType.year:
        return yearFlex;
      case DateTimeType.month:
        return monthFlex;
      case DateTimeType.day:
        return dayFlex;
      case DateTimeType.weekday:
        return weekdayFlex;
      case DateTimeType.hour24:
        return hour24Flex;
      case DateTimeType.hour12:
        return hour12Flex;
      case DateTimeType.minute:
        return minuteFlex;
      case DateTimeType.second:
        return secondFlex;
      case DateTimeType.amPM:
        return amPMFlex;
    }
  }
}
