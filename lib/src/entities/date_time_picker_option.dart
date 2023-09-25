part of '../scroll_date_time_picker.dart';

/// Set datetime configuration for the picker
class DateTimePickerOption {
  const DateTimePickerOption({
    required this.dateFormat,
    required this.minDate,
    required this.maxDate,
    this.initialDate,
  });

  /// Format used in the picker.
  ///
  /// The picker will automatically parse the format
  /// and show datetime according to DateFormat's pattern.
  /// Locale could also pass to this param to set the datetime picker locale.
  ///
  /// Example:
  ///
  ///       DateFormat.yMMMd();
  ///       DateFormat('hhmmss');
  ///       DateFormat.yMMMd('en');
  ///       DateFormat('hhmmssa', 'fr');
  final DateFormat dateFormat;

  /// Minimum date allowed to be chosen.
  ///
  /// If a date is before minimum date, date item in the picker
  /// will be disabled and not allowed to be chosen
  /// 
  /// Example:
  ///
  ///       DateTime.now().substract(Duration(days: 200));
  ///       DateTime(2020, 6);
  final DateTime minDate;

  /// Maximum date allowed to be chosen.
  ///
  /// If a date is after maximum date, date item in the picker
  /// will be disabled and not allowed to be chosen
  /// 
  /// Example:
  ///
  ///       DateTime.now().add(Duration(days: 200));
  ///       DateTime(2024, 6);
  final DateTime maxDate;

  /// Initial date to be shown in the picker.
  /// 
  /// If null, fallback to: 
  /// 
  ///       DateTime.now() 
  final DateTime? initialDate;

  Locale get locale => Locale(dateFormat.locale);
  DateTime get getInitialDate => initialDate ?? DateTime.now();
}

extension _DateTimePickerOptionX on DateTimePickerOption {
  List<String> get patterns {
    if (dateFormat.pattern == null) {
      throw Exception('DateFormat is not valid: $dateFormat');
    }

    final pattern = dateFormat.pattern!.replaceAll(RegExp('[^a-zA-Z]'), '');
    final result = <String>[];
    final buffer = StringBuffer();

    for (var i = 0; i < pattern.length; i++) {
      final currentChar = pattern[i];

      // Write to buffer if first index
      if (i == 0) {
        buffer.write(currentChar);
        continue;
      }

      // If current char is same, add to buffer
      if (currentChar == buffer.toString()[0]) {
        buffer.write(currentChar);
      }

      // If current char is different, write buffer to result and reset buffer
      else {
        result.add(buffer.toString());
        buffer
          ..clear()
          ..write(currentChar);
      }

      // Add to result if its last char
      if (i == pattern.length - 1) {
        result.add(buffer.toString());
      }
    }

    return result;
  }

  List<_DateTimeType> get dateTimeTypes => patterns
      .map(
        _DateTimeType.fromPattern,
      )
      .toList();
}
