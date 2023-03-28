part of 'scroll_date_picker.dart';

class DatePickerStyle {
  const DatePickerStyle({
    this.activeStyle,
    this.inactiveStyle,
    this.activeDecoration,
    this.inactiveDecoration,
    this.disabledStyle = const TextStyle(color: Colors.grey),
    this.centerDecoration = const BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.grey),
        bottom: BorderSide(color: Colors.grey),
      ),
    ),
  });

  final TextStyle? activeStyle;
  final TextStyle? inactiveStyle;
  final TextStyle disabledStyle;

  final BoxDecoration? activeDecoration;
  final BoxDecoration? inactiveDecoration;
  final BoxDecoration? centerDecoration;
}
