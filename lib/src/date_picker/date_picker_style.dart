part of 'scroll_date_picker.dart';

class DatePickerStyle {
  DatePickerStyle({
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
          centerDecoration?.color != null,
          'Center decoration should have background color',
        );

  final TextStyle? activeStyle;
  final TextStyle? inactiveStyle;
  final TextStyle disabledStyle;

  final BoxDecoration? activeDecoration;
  final BoxDecoration? inactiveDecoration;
  final BoxDecoration? centerDecoration;
}
