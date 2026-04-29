part of '../scroll_date_time_picker.dart';

/// Class representing customizable prefix widgets for a datetime picker.
///
/// This class allows you to define custom prefix widgets for different date and time items
/// in a datetime picker. Each widget can be customized independently for various date and
/// time types such as year, month, day, hour, and more.
///
/// The provided [builder] can be used to customize the layout and fully build the prefix
/// widgets of the scroll datetime picker. In contrast, the individual widget parameters (`year`, `month`, `day`, etc.) are used to draw
/// custom prefix widgets specifically for their corresponding date or time type.
class DateTimePickerPrefixWidget {
  /// Creates an instance of [DateTimePickerPrefixWidget].
  ///
  /// - [year]: Custom prefix widget for the year item.
  /// - [month]: Custom prefix widget for the month item.
  /// - [day]: Custom prefix widget for the day item.
  /// - [weekday]: Custom prefix widget for the weekday item.
  /// - [hour24]: Custom prefix widget for the 24-hour format hour item.
  /// - [hour12]: Custom prefix widget for the 12-hour format hour item.
  /// - [minute]: Custom prefix widget for the minute item.
  /// - [second]: Custom prefix widget for the second item.
  /// - [amPM]: Custom prefix widget for the AM/PM item.
  /// - [builder]: A function to fully build the prefix widgets of the scroll
  ///   datetime picker, taking the [BuildContext], [BoxConstraints], and
  ///   [Widget] child as parameters and returning a custom [Widget].
  ///
  ///   The [child] parameter in the function will contain the widgets passed
  ///   to the individual widget parameters (`year`, `month`, `day`, etc.).
  ///   If an individual widget parameter is null, the [child] will be an empty
  ///   widget such as`SizedBox` as the default child widget.
  ///   If all the parameters for the individual prefix widgets for each date/time type,
  ///   then the child will be a SizedBox.
  const DateTimePickerPrefixWidget({
    this.year,
    this.month,
    this.day,
    this.weekday,
    this.hour24,
    this.hour12,
    this.minute,
    this.second,
    this.amPM,
    this.builder,
  });

  /// Function to fully build the prefix widgets of the scroll datetime picker.
  ///
  /// This function receives the [BuildContext], [BoxConstraints], and [Widget] child
  /// as parameters and returns a custom [Widget]. This custom prefix widget will
  /// be placed before each item type in the datetime picker.
  ///
  /// The [child] parameter will contain the widgets passed to the individual widget
  /// parameters (`year`, `month`, `day`, etc.). If any individual widget parameter is
  /// null, the [child] will be a `SizedBox` as the default child widget.
  ///
  /// If all the parameters for the individual prefix widget for each date/time type,
  /// then the child will be a SizedBox.
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    Widget child,
  )? builder;

  /// Custom prefix widget for the year item.
  ///
  /// This widget will be placed before the year picker in the datetime picker.
  final Widget? year;

  /// Custom prefix widget for the month item.
  ///
  /// This widget will be placed before the month picker in the datetime picker.
  final Widget? month;

  /// Custom prefix widget for the day item.
  ///
  /// This widget will be placed before the day picker in the datetime picker.
  final Widget? day;

  /// Custom prefix widget for the weekday item.
  ///
  /// This widget will be placed before the weekday picker in the datetime picker.
  final Widget? weekday;

  /// Custom prefix widget for the 24-hour format hour item.
  ///
  /// This widget will be placed before the 24-hour picker in the datetime picker.
  final Widget? hour24;

  /// Custom prefix widget for the 12-hour format hour item.
  ///
  /// This widget will be placed before the 12-hour picker in the datetime picker.
  final Widget? hour12;

  /// Custom prefix widget for the minute item.
  ///
  /// This widget will be placed before the minute picker in the datetime picker.
  final Widget? minute;

  /// Custom prefix widget for the second item.
  ///
  /// This widget will be placed before the second picker in the datetime picker.
  final Widget? second;

  /// Custom prefix widget for the AM/PM item.
  ///
  /// This widget will be placed before the AM/PM picker in the datetime picker.
  final Widget? amPM;
}

/// Extension providing additional methods for `DateTimePickerPrefixWidget`.
///
/// This extension includes methods for checking the presence of custom prefix
/// widgets for individual date or time types, as well as retrieving the prefix
/// widget for a specific date or time type.
extension DateTimePickerPrefixWidgetX on DateTimePickerPrefixWidget {
  /// Indicates whether any type-specific custom prefix widget is set.
  ///
  /// This property checks if any of the type-specific custom prefix widget
  /// parameters (`year`, `month`, `day`, `weekday`, `hour24`, `hour12`,
  /// `minute`, `second`, `amPM`) are set to non-null values.
  ///
  /// - Returns `true` if any type-specific custom prefix widget is set;
  ///   otherwise, returns `false`.
  bool get hasTypeSpecificPrefixWidgets =>
      year != null ||
      month != null ||
      day != null ||
      weekday != null ||
      hour24 != null ||
      hour12 != null ||
      minute != null ||
      second != null ||
      amPM != null;

  /// Counts the number of prefix widgets that are set (non-null).
  ///
  /// This method iterates through all the prefix widget properties and counts
  /// how many of them are not null.
  ///
  /// - Returns the count of non-null prefix widgets.
  int countSetWidgets() {
    var count = 0;

    if (year != null) count++;
    if (month != null) count++;
    if (day != null) count++;
    if (weekday != null) count++;
    if (hour24 != null) count++;
    if (hour12 != null) count++;
    if (minute != null) count++;
    if (second != null) count++;
    if (amPM != null) count++;

    return count;
  }

  /// Retrieves the prefix widget for a specific [DateTimeType].
  ///
  /// - [type]: The date or time type for which to get the prefix widget.
  /// - Returns the custom prefix widget for the specified date or time type, or `null` if not set.
  Widget? getPrefixWidget(DateTimeType type) {
    switch (type) {
      case DateTimeType.year:
        return year;
      case DateTimeType.month:
        return month;
      case DateTimeType.day:
        return day;
      case DateTimeType.weekday:
        return weekday;
      case DateTimeType.hour24:
        return hour24;
      case DateTimeType.hour12:
        return hour12;
      case DateTimeType.minute:
        return minute;
      case DateTimeType.second:
        return second;
      case DateTimeType.amPM:
        return amPM;
    }
  }
}
