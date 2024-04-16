part of '../scroll_date_time_picker.dart';

/// Class representing customizable center widgets for a datetime picker.
///
/// This class allows you to define custom center widgets for different date and time items
/// in a datetime picker. Each widget can be customized independently for various date and
/// time types such as year, month, day, hour, and more.
///
/// The provided [builder] can be used to customize the layout and fully build the center
/// widget of the scroll datetime picker. In contrast, the individual widget parameters (`year`, `month`, `day`, etc.) are used to draw
/// custom center widgets specifically for their corresponding date or time type.
class DateTimePickerCenterWidget {
  /// Creates an instance of [DateTimePickerCenterWidget].
  ///
  /// - [year]: Custom widget for the center area of the year item.
  /// - [month]: Custom widget for the center area of the month item.
  /// - [day]: Custom widget for the center area of the day item.
  /// - [weekday]: Custom widget for the center area of the weekday item.
  /// - [hour24]: Custom widget for the center area of the 24-hour format hour item.
  /// - [hour12]: Custom widget for the center area of the 12-hour format hour item.
  /// - [minute]: Custom widget for the center area of the minute item.
  /// - [second]: Custom widget for the center area of the second item.
  /// - [amPM]: Custom widget for the center area of the AM/PM item.
  /// - [builder]: A function to fully build the center widget of the scroll
  ///   datetime picker, taking the [BuildContext], [BoxConstraints], and
  ///   [Widget] child as parameters and returning a custom [Widget].
  ///
  ///   The [child] parameter in the function will contain the widgets passed
  ///   to the individual widget parameters (`year`, `month`, `day`, etc.).
  ///   If an individual widget parameter is null, the [child] will be an empty
  ///   widget such as`SizedBox` as the default child widget.
  ///   If all the parameters for the individual center widget for each date/time type,
  ///   then the child will be a SizedBox.
  const DateTimePickerCenterWidget({
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

  /// Function to fully build the center widget of the scroll datetime picker.
  ///
  /// This function receives the [BuildContext], [BoxConstraints], and [Widget] child
  /// as parameters and returns a custom [Widget]. This custom center widget will
  /// encompass all date and time types in the datetime picker.
  ///
  /// The [child] parameter will contain the widgets passed to the individual widget
  /// parameters (`year`, `month`, `day`, etc.). If any individual widget parameter is
  /// null, the [child] will be a `SizedBox` as the default child widget.
  ///
  /// If all the parameters for the individual center widget for each date/time type,
  /// then the child will be a SizedBox.
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    Widget child,
  )? builder;

  /// Custom widget for the center area of the year item.
  ///
  /// This widget will only draw the center area for the year type in the datetime picker.
  final Widget? year;

  /// Custom widget for the center area of the month item.
  ///
  /// This widget will only draw the center area for the month type in the datetime picker.
  final Widget? month;

  /// Custom widget for the center area of the day item.
  ///
  /// This widget will only draw the center area for the day type in the datetime picker.
  final Widget? day;

  /// Custom widget for the center area of the weekday item.
  ///
  /// This widget will only draw the center area for the weekday type in the datetime picker.
  final Widget? weekday;

  /// Custom widget for the center area of the 24-hour format hour item.
  ///
  /// This widget will only draw the center area for the 24-hour format hour type in the datetime picker.
  final Widget? hour24;

  /// Custom widget for the center area of the 12-hour format hour item.
  ///
  /// This widget will only draw the center area for the 12-hour format hour type in the datetime picker.
  final Widget? hour12;

  /// Custom widget for the center area of the minute item.
  ///
  /// This widget will only draw the center area for the minute type in the datetime picker.
  final Widget? minute;

  /// Custom widget for the center area of the second item.
  ///
  /// This widget will only draw the center area for the second type in the datetime picker.
  final Widget? second;

  /// Custom widget for the center area of the AM/PM item.
  ///
  /// This widget will only draw the center area for the AM/PM type in the datetime picker.
  final Widget? amPM;
}

/// Extension providing additional methods for `DateTimePickerCenterWidget`.
///
/// This extension includes methods for checking the presence of custom center
/// widgets for individual date or time types, as well as retrieving the center
/// widget for a specific date or time type.
extension _DateTimePickerCenterWidgetX on DateTimePickerCenterWidget {
  /// Indicates whether any type-specific custom center widget is set.
  ///
  /// This property checks if any of the type-specific custom center widget
  /// parameters (`year`, `month`, `day`, `weekday`, `hour24`, `hour12`,
  /// `minute`, `second`, `amPM`) are set to non-null values.
  ///
  /// - Returns `true` if any type-specific custom center widget is set;
  ///   otherwise, returns `false`.
  bool get hasTypeSpecificCenterWidgets =>
      year != null ||
      month != null ||
      day != null ||
      weekday != null ||
      hour24 != null ||
      hour12 != null ||
      minute != null ||
      second != null ||
      amPM != null;

  /// Retrieves the center widget for a specific [DateTimeType].
  ///
  /// - [type]: The date or time type for which to get the center widget.
  /// - Returns the custom center widget for the specified date or time type, or `null` if not set.
  Widget? getCenterWidget(DateTimeType type) {
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
