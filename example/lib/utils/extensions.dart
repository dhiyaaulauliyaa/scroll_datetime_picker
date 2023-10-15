import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

extension DateTimePickerStyleX on DateTimePickerStyle {
  DateTimePickerStyle copyWith({
    TextStyle? activeStyle,
    TextStyle? inactiveStyle,
    TextStyle? disabledStyle,
    BoxDecoration? activeDecoration,
    BoxDecoration? inactiveDecoration,
    BoxDecoration? centerDecoration,
  }) =>
      DateTimePickerStyle(
        activeStyle: activeStyle ?? this.activeStyle,
        inactiveStyle: inactiveStyle ?? this.inactiveStyle,
        disabledStyle: disabledStyle ?? this.disabledStyle,
        activeDecoration: activeDecoration ?? this.activeDecoration,
        inactiveDecoration: inactiveDecoration ?? this.inactiveDecoration,
        centerDecoration: centerDecoration ?? this.centerDecoration,
      );
}

extension DateTimePickerWheelOptionX on DateTimePickerWheelOption {
  DateTimePickerWheelOption copyWith({
    ScrollPhysics? physics,
    Clip? clipBehavior,
    bool? renderChildrenOutsideViewport,
    double? perspective,
    double? diameterRatio,
    double? offAxisFraction,
    double? squeeze,
  }) =>
      DateTimePickerWheelOption(
        physics: physics ?? this.physics,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        renderChildrenOutsideViewport:
            renderChildrenOutsideViewport ?? this.renderChildrenOutsideViewport,
        perspective: perspective ?? this.perspective,
        diameterRatio: diameterRatio ?? this.diameterRatio,
        offAxisFraction: offAxisFraction ?? this.offAxisFraction,
        squeeze: squeeze ?? this.squeeze,
      );
}

extension DateTimePickerOptionX on DateTimePickerOption {
  DateTimePickerOption copyWith({
    DateFormat? dateFormat,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? initialDate,
  }) =>
      DateTimePickerOption(
        dateFormat: dateFormat ?? this.dateFormat,
        minDate: minDate ?? this.minDate,
        maxDate: maxDate ?? this.maxDate,
        initialDate: initialDate ?? this.initialDate,
      );
}

extension StringX on String {
  bool get checkPatternValidity {
    final firstChar = this[0];

    if (firstChar == 'y') return true;
    if (firstChar == 'M') return true;
    if (firstChar == 'd') return true;
    if (firstChar == 'E') return true;
    if (firstChar == 'H') return true;
    if (firstChar == 'h') return true;
    if (firstChar == 'm') return true;
    if (firstChar == 's') return true;
    if (firstChar == 'a') return true;

    // Special cases
    if (this == 'j') return true;
    if (this == 'c') return true;
    if (this == 'cc') return true;
    if (this == 'ccc') return true;
    if (this == 'cccc') return true;
    if (this == 'LLL') return true;
    if (this == 'LLLL') return true;

    return false;
  }
}
