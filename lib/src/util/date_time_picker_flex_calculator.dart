part of '../scroll_date_time_picker.dart';

/// A utility class for calculating the total applied flex in the ScrollDateTimePicker.
class DateTimePickerFlexCalculator {
  /// Calculates the total flex applied in the ScrollDateTimePicker based on:
  /// - [DateTimePickerItemFlex] values for every [DateTimeType] in [dateTimeTypes]
  /// - [DateTimePickerPrefixFlex] values for [DateTimeType]s that have a
  ///   matching widget in [DateTimePickerPrefixWidget]
  ///
  /// Returns the total calculated flex value.
  static int calculateTotalFlex({
    required List<DateTimeType> dateTimeTypes,
    required DateTimePickerItemFlex itemFlex,
    required DateTimePickerPrefixFlex prefixFlex,
    required DateTimePickerPrefixWidget prefixWidget,
  }) {
    // Item flex is applied for every DateTimeType present in the format
    final int itemFlexTotal = dateTimeTypes.fold(0, (sum, type) {
      return sum + itemFlex.getFlex(type);
    });

    // Prefix flex is applied only when a widget is set for the type
    final int prefixFlexTotal = dateTimeTypes.fold(0, (sum, type) {
      final hasWidget = prefixWidget.getPrefixWidget(type) != null;
      return sum + (hasWidget ? prefixFlex.getFlex(type) : 0);
    });

    return itemFlexTotal + prefixFlexTotal;
  }

  /// Calculates the pixel-width distribution for every item/prefix slot.
  ///
  /// Returns a map whose keys are `'<type.name>_item'` and (when a prefix
  /// widget is present) `'<type.name>_prefix'`, and whose values are the
  /// corresponding pixel widths inside [containerWidth].
  static Map<String, double> calculateFlexWidthDistribution({
    required List<DateTimeType> dateTimeTypes,
    required DateTimePickerItemFlex itemFlex,
    required DateTimePickerPrefixFlex prefixFlex,
    required DateTimePickerPrefixWidget prefixWidget,
    required double containerWidth,
  }) {
    final totalFlex = calculateTotalFlex(
      dateTimeTypes: dateTimeTypes,
      itemFlex: itemFlex,
      prefixFlex: prefixFlex,
      prefixWidget: prefixWidget,
    );

    if (totalFlex == 0) return {};

    final Map<String, double> flexWidths = {};

    for (final type in dateTimeTypes) {
      final itemFlexValue = itemFlex.getFlex(type);
      final hasPrefixWidget = prefixWidget.getPrefixWidget(type) != null;
      final prefixFlexValue = hasPrefixWidget ? prefixFlex.getFlex(type) : 0;

      flexWidths['${type.name}_item'] =
          (itemFlexValue / totalFlex) * containerWidth;

      if (hasPrefixWidget) {
        flexWidths['${type.name}_prefix'] =
            (prefixFlexValue / totalFlex) * containerWidth;
      }
    }

    return flexWidths;
  }
}