part of '../scroll_date_time_picker.dart';

/// Class to specify the flex width (proportional space) for different date and time
/// items in a datetime picker.
///
/// This class provides a way to customize the width allocation for each item in
/// a datetime picker. By adjusting the flex values for each date/time item, you can
/// control the visual spacing and layout of the datetime picker items.
class DateTimePickerItemFlex {
  /// Creates an instance of [DateTimePickerItemFlex].
  ///
  /// All parameters are optional and default to 1.
  ///
  /// - [yearFlex]: The flex width for the year item.
  /// - [monthFlex]: The flex width for the month item.
  /// - [dayFlex]: The flex width for the day item.
  /// - [weekdayFlex]: The flex width for the weekday item.
  /// - [hour24Flex]: The flex width for the 24-hour format hour item.
  /// - [hour12Flex]: The flex width for the 12-hour format hour item.
  /// - [minuteFlex]: The flex width for the minute item.
  /// - [secondFlex]: The flex width for the second item.
  /// - [amPMFlex]: The flex width for the AM/PM item.
  const DateTimePickerItemFlex({
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

  /// The flex width for the year item.
  final int yearFlex;

  /// The flex width for the month item.
  final int monthFlex;

  /// The flex width for the day item.
  final int dayFlex;

  /// The flex width for the weekday item.
  final int weekdayFlex;

  /// The flex width for the 24-hour format hour item.
  final int hour24Flex;

  /// The flex width for the 12-hour format hour item.
  final int hour12Flex;

  /// The flex width for the minute item.
  final int minuteFlex;

  /// The flex width for the second item.
  final int secondFlex;

  /// The flex width for the AM/PM item.
  final int amPMFlex;
}

/// Extension to retrieve the flex width for a specific [DateTimeType].
extension _DateTimePickerItemX on DateTimePickerItemFlex {
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
