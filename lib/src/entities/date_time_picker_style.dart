part of '../scroll_date_time_picker.dart';

/// Set styles for the DateTime picker widget
class DateTimePickerStyle {
  DateTimePickerStyle({
    this.activeStyle,
    this.inactiveStyle,
    this.activeDecoration,
    this.inactiveDecoration,
    this.disabledStyle = const TextStyle(color: Colors.grey),
    this.centerDecoration = const BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(color: Colors.grey),
        bottom: BorderSide(color: Colors.grey),
      ),
    ),
  }) : assert(
          centerDecoration.color != null,
          'Center decoration should have background color',
        );

  /// TextStyle to be used for the widget in the center of the picker.
  /// Item that shown with this style will be set for the new value.
  ///
  /// Typically have bigger font size than `[inactiveStyle]`
  /// to create maginfying effect
  final TextStyle? activeStyle;

  /// TextStyle to be used for the widget outside the center of the picker.
  /// Item that shown with this style will not be set for the new value.
  ///
  /// Typically have smaller font size than `[activeStyle]`
  /// to create maginfying effect for the active value
  final TextStyle? inactiveStyle;

  /// TextStyle to be used for the value that is not valid / can't be selected
  /// such as:
  ///   - Day 28/29-31 in the month of February,
  ///   - Day 31 for the months that only has 30 days
  ///   - Date before `[DateTimePickerOption.minDate]`
  ///   - Date after `[DateTimePickerOption.maxDate]`
  ///
  /// The value shown in this style can't be selected. If selected, the picker
  /// will automatically revert to its previous value
  ///
  /// Defaults to:
  ///
  ///       TextStyle(color: Colors.grey),
  final TextStyle disabledStyle;

  /// Decoration to be used for the widget in the center of the picker.
  /// Item that shown with this style will be set for the new value.
  final BoxDecoration? activeDecoration;

  /// Decoration to be used for the widget outside the center of the picker.
  /// Item that shown with this style won't be set for the new value.
  final BoxDecoration? inactiveDecoration;

  /// Decoration for the center area of the picker
  ///
  /// Should have a background color to prevent overlap visibility
  /// with inactive values
  ///
  /// Defaults to:
  ///
  ///        BoxDecoration(
  ///          color: Colors.white,
  ///          border: Border(
  ///            top: BorderSide(color: Colors.grey),
  ///            bottom: BorderSide(color: Colors.grey),
  ///          ),
  ///        ),
  final BoxDecoration centerDecoration;
}
