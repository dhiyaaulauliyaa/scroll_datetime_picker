part of '../scroll_date_time_picker.dart';

class DateTimePickerOption {
  const DateTimePickerOption({
    required this.dateFormat,
    this.minDate,
    this.maxDate,
    this.initialDate,
    this.locale = const Locale('en', 'US'),
  });

  final DateFormat dateFormat;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? initialDate;
  final Locale locale;

  DateTime get getMinDate => minDate ?? DateTime(DateTime.now().year - 1);
  DateTime get getMaxDate => maxDate ?? DateTime(DateTime.now().year + 1);
  DateTime get getInitialDate => initialDate ?? DateTime.now();
}

extension _DatePickerOptionX on DateTimePickerOption {
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
