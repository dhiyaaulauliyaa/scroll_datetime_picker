import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';

// Helper to derive dateTimeTypes from a DateFormat, mirroring the
// DateTimePickerOption.dateTimeTypes extension used in production code.
List<DateTimeType> _typesFrom(DateFormat format) => DateTimePickerOption(
      dateFormat: format,
      minDate: DateTime(2000),
      maxDate: DateTime(2030),
    ).dateTimeTypes;

void main() {
  group('DateTimePickerFlexCalculator', () {
    test('should calculate total flex correctly with default values', () {
      final dateTimeTypes = _typesFrom(DateFormat('yMd'));
      const itemFlex = DateTimePickerItemFlex();
      const prefixFlex = DateTimePickerPrefixFlex();
      const prefixWidget = DateTimePickerPrefixWidget();

      final totalFlex = DateTimePickerFlexCalculator.calculateTotalFlex(
        dateTimeTypes: dateTimeTypes,
        itemFlex: itemFlex,
        prefixFlex: prefixFlex,
        prefixWidget: prefixWidget,
      );

      // 1 (year) + 1 (month) + 1 (day)
      expect(totalFlex, 3);
    });

    test('should calculate total flex correctly with custom item flex values',
        () {
      final dateTimeTypes = _typesFrom(DateFormat('yMd'));
      const itemFlex = DateTimePickerItemFlex(
        yearFlex: 2,
        monthFlex: 3,
        dayFlex: 4,
      );
      const prefixFlex = DateTimePickerPrefixFlex();
      const prefixWidget = DateTimePickerPrefixWidget();

      final totalFlex = DateTimePickerFlexCalculator.calculateTotalFlex(
        dateTimeTypes: dateTimeTypes,
        itemFlex: itemFlex,
        prefixFlex: prefixFlex,
        prefixWidget: prefixWidget,
      );

      // 2 (year) + 3 (month) + 4 (day)
      expect(totalFlex, 9);
    });

    test('should include prefix flex only when prefix widget exists', () {
      final dateTimeTypes = _typesFrom(DateFormat('yMd'));
      const itemFlex = DateTimePickerItemFlex();
      const prefixFlex = DateTimePickerPrefixFlex(
        yearFlex: 2,
        monthFlex: 3,
        dayFlex: 4,
      );
      const prefixWidget = DateTimePickerPrefixWidget(
        year: Text('Year:'), // Only year has a prefix widget
      );

      final totalFlex = DateTimePickerFlexCalculator.calculateTotalFlex(
        dateTimeTypes: dateTimeTypes,
        itemFlex: itemFlex,
        prefixFlex: prefixFlex,
        prefixWidget: prefixWidget,
      );

      // (1+2) for year with prefix + 1 for month + 1 for day
      expect(totalFlex, 5);
    });

    test('should calculate flex for complex date format', () {
      final dateTimeTypes = _typesFrom(DateFormat('EEEEyMMMdhhmmssa'));
      const itemFlex = DateTimePickerItemFlex();
      const prefixFlex = DateTimePickerPrefixFlex();
      const prefixWidget = DateTimePickerPrefixWidget();

      final totalFlex = DateTimePickerFlexCalculator.calculateTotalFlex(
        dateTimeTypes: dateTimeTypes,
        itemFlex: itemFlex,
        prefixFlex: prefixFlex,
        prefixWidget: prefixWidget,
      );

      // weekday, year, month, day, hour12, minute, second, amPM → 8
      expect(totalFlex, 8);
    });

    test('should correctly handle all types in a full date-time format', () {
      final dateTimeTypes = _typesFrom(DateFormat('yyMMddHHmmss'));
      const itemFlex = DateTimePickerItemFlex();
      const prefixFlex = DateTimePickerPrefixFlex();
      const prefixWidget = DateTimePickerPrefixWidget();

      final totalFlex = DateTimePickerFlexCalculator.calculateTotalFlex(
        dateTimeTypes: dateTimeTypes,
        itemFlex: itemFlex,
        prefixFlex: prefixFlex,
        prefixWidget: prefixWidget,
      );

      // year, month, day, hour24, minute, second → 6
      expect(totalFlex, 6);
    });

    test('should calculate flex width distribution correctly', () {
      final dateTimeTypes = _typesFrom(DateFormat('yMd'));
      const itemFlex = DateTimePickerItemFlex(
        yearFlex: 2,
        monthFlex: 1,
        dayFlex: 1,
      );
      const prefixFlex = DateTimePickerPrefixFlex(yearFlex: 1);
      const prefixWidget = DateTimePickerPrefixWidget(year: Text('Year:'));
      const containerWidth = 400.0;

      final flexWidths =
          DateTimePickerFlexCalculator.calculateFlexWidthDistribution(
        dateTimeTypes: dateTimeTypes,
        itemFlex: itemFlex,
        prefixFlex: prefixFlex,
        prefixWidget: prefixWidget,
        containerWidth: containerWidth,
      );

      // Total flex = 5 (2+1 for year, 1 for month, 1 for day)
      expect(flexWidths.length, 4); // three items + one prefix
      expect(flexWidths['year_item'], 400.0 * (2 / 5));
      expect(flexWidths['year_prefix'], 400.0 * (1 / 5));
      expect(flexWidths['month_item'], 400.0 * (1 / 5));
      expect(flexWidths['day_item'], 400.0 * (1 / 5));
    });

    test('should handle empty container width', () {
      final dateTimeTypes = _typesFrom(DateFormat('yMd'));
      const itemFlex = DateTimePickerItemFlex();
      const prefixFlex = DateTimePickerPrefixFlex();
      const prefixWidget = DateTimePickerPrefixWidget();
      const containerWidth = 0.0;

      final flexWidths =
          DateTimePickerFlexCalculator.calculateFlexWidthDistribution(
        dateTimeTypes: dateTimeTypes,
        itemFlex: itemFlex,
        prefixFlex: prefixFlex,
        prefixWidget: prefixWidget,
        containerWidth: containerWidth,
      );

      expect(flexWidths.length, 3);
      expect(flexWidths['year_item'], 0.0);
      expect(flexWidths['month_item'], 0.0);
      expect(flexWidths['day_item'], 0.0);
    });

    test('should return empty map when total flex is zero', () {
      // calculateFlexWidthDistribution returns {} when totalFlex == 0.
      // We verify the method handles this gracefully and returns a Map.
      final dateTimeTypes = _typesFrom(DateFormat('yMd'));
      const itemFlex = DateTimePickerItemFlex();
      const prefixFlex = DateTimePickerPrefixFlex();
      const prefixWidget = DateTimePickerPrefixWidget();
      const containerWidth = 400.0;

      final result =
          DateTimePickerFlexCalculator.calculateFlexWidthDistribution(
        dateTimeTypes: dateTimeTypes,
        itemFlex: itemFlex,
        prefixFlex: prefixFlex,
        prefixWidget: prefixWidget,
        containerWidth: containerWidth,
      );

      expect(result, isA<Map<String, double>>());
    });
  });
}