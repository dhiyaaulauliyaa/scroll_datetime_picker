part of '../scroll_date_time_picker.dart';

/// A utility class for calculating the total applied flex in the ScrollDateTimePicker.
class DateTimePickerFlexCalculator {
  /// Calculates the total flex applied in the ScrollDateTimePicker based on:
  /// - DateTimePickerItemFlex values for DateTimeTypes provided in DateFormat
  /// - DateTimePickerPrefixFlex values for DateTimeTypes that have a matching widget in DateTimePickerPrefixWidget
  ///
  /// Returns the total calculated flex value.
  static int calculateTotalFlex({
    required DateFormat dateFormat,
    required DateTimePickerItemFlex itemFlex,
    required DateTimePickerPrefixFlex prefixFlex,
    required DateTimePickerPrefixWidget prefixWidget,
  }) {
    // Get the dateTimeTypes from DateFormat
    final dateTimeTypes = _getDateTimeTypesFromDateFormat(dateFormat);

    // Calculate item flex - applied for all DateTimeTypes present in DateFormat
    final int itemFlexTotal = dateTimeTypes.fold(0, (sum, type) {
      return sum + itemFlex.getFlex(type);
    });

    // Calculate prefix flex - applied only when a widget is set for the type
    final int prefixFlexTotal = dateTimeTypes.fold(0, (sum, type) {
      final hasWidget = prefixWidget.getPrefixWidget(type) != null;
      return sum + (hasWidget ? prefixFlex.getFlex(type) : 0);
    });

    return itemFlexTotal + prefixFlexTotal;
  }

  /// Gets the list of DateTimeTypes from a DateFormat.
  static List<DateTimeType> _getDateTimeTypesFromDateFormat(
      DateFormat dateFormat) {
    if (dateFormat.pattern == null) {
      throw Exception('DateFormat is not valid: $dateFormat');
    }

    final pattern = dateFormat.pattern!.replaceAll(RegExp('[^a-zA-Z]'), '');
    final List<String> patterns = _extractPatterns(pattern);

    return patterns.map(DateTimeType.fromPattern).toList();
  }

  /// Extracts individual patterns from a combined pattern string.
  static List<String> _extractPatterns(String pattern) {
    final result = <String>[];
    final buffer = StringBuffer();

    for (var i = 0; i < pattern.length; i++) {
      final currentChar = pattern[i];

      // Write to buffer if first index
      if (i == 0) {
        buffer.write(currentChar);
      }
      // If current char is same, add to buffer
      else if (currentChar == buffer.toString()[0]) {
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

  /// A convenience method to calculate total width based on flex values and a fixed container width.
  /// This helps determine the actual pixel width each component will take.
  static Map<String, double> calculateFlexWidthDistribution({
    required DateFormat dateFormat,
    required DateTimePickerItemFlex itemFlex,
    required DateTimePickerPrefixFlex prefixFlex,
    required DateTimePickerPrefixWidget prefixWidget,
    required double containerWidth,
  }) {
    final totalFlex = calculateTotalFlex(
      dateFormat: dateFormat,
      itemFlex: itemFlex,
      prefixFlex: prefixFlex,
      prefixWidget: prefixWidget,
    );

    if (totalFlex == 0) return {};

    final dateTimeTypes = _getDateTimeTypesFromDateFormat(dateFormat);
    final Map<String, double> flexWidths = {};

    // Calculate width for each DateTimeType
    for (final type in dateTimeTypes) {
      final itemFlexValue = itemFlex.getFlex(type);
      final hasPrefixWidget = prefixWidget.getPrefixWidget(type) != null;
      final prefixFlexValue = hasPrefixWidget ? prefixFlex.getFlex(type) : 0;

      final double itemWidth = (itemFlexValue / totalFlex) * containerWidth;
      flexWidths['${type.name}_item'] = itemWidth;

      if (hasPrefixWidget) {
        final double prefixWidth =
            (prefixFlexValue / totalFlex) * containerWidth;
        flexWidths['${type.name}_prefix'] = prefixWidth;
      }
    }

    return flexWidths;
  }
}
