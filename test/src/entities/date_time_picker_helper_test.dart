import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:scroll_datetime_picker/src/entities/date_time_picker_helper.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';

void main() {
  group('test DateTimePickerHelper', () {
    final helper = DateTimePickerHelper(
      DateTimePickerOption(
        dateFormat: DateFormat('yy-MMM-dd hh:mm:ss a'),
        minDate: DateTime(2020, 6),
        maxDate: DateTime(2024, 1, 1, 23, 59, 59),
      ),
      const DateTimePickerItemFlex(),
      const DateTimePickerPrefixFlex(),
    );

    test(
      'when called, isAM method should return correct value',
      () async {
        expect(helper.isAM(0), true);
        expect(helper.isAM(1), true);
        expect(helper.isAM(12), false);
        expect(helper.isAM(23), false);
        expect(helper.isAM(24), false);
      },
    );

    test(
      'when called, convertToHour12 method should return correct value',
      () async {
        expect(helper.convertToHour12(0), 12);
        expect(helper.convertToHour12(1), 1);
        expect(helper.convertToHour12(12), 12);
        expect(helper.convertToHour12(23), 11);
        expect(helper.convertToHour12(24), 12);
      },
    );

    test(
      'when called, convertToHour12 getter should return correct value',
      () async {
        expect(helper.numOfYear, 5);
      },
    );

    test(
      'when called, maxDay method should return correct value',
      () async {
        expect(helper.maxDay(1, 2020), 31);
        expect(helper.maxDay(2, 2020), 29);
        expect(helper.maxDay(2, 2021), 28);
        expect(helper.maxDay(6, 2021), 30);
        expect(helper.maxDay(12, 2021), 31);
      },
    );

    test(
      'when called, years getter should return correct value',
      () async {
        expect(helper.years, [2020, 2021, 2022, 2023, 2024]);
      },
    );

    test(
      'when called, itemCount method should return correct value',
      () async {
        expect(helper.itemCount(DateTimeType.year), 5);
        expect(helper.itemCount(DateTimeType.month), 12);
        expect(helper.itemCount(DateTimeType.day), 31);
        expect(helper.itemCount(DateTimeType.weekday), 7);
        expect(helper.itemCount(DateTimeType.hour24), 24);
        expect(helper.itemCount(DateTimeType.hour12), 12);
        expect(helper.itemCount(DateTimeType.minute), 60);
        expect(helper.itemCount(DateTimeType.second), 60);
        expect(helper.itemCount(DateTimeType.amPM), 2);
      },
    );

    test(
      'when called, getText method should return correct value',
      () async {
        expect(helper.getText(DateTimeType.year, 'yy', 1), '21');
        expect(helper.getText(DateTimeType.month, 'MMM', 1), 'Feb');
        expect(helper.getText(DateTimeType.day, 'dd', 1), '02');
        expect(helper.getText(DateTimeType.weekday, 'E', 1), 'Tue');
        expect(helper.getText(DateTimeType.hour24, 'HH', 15), '15');
        expect(helper.getText(DateTimeType.hour12, 'hh', 15), '04');
        expect(helper.getText(DateTimeType.minute, 'mm', 1), '01');
        expect(helper.getText(DateTimeType.second, 'ss', 1), '01');
        expect(helper.getText(DateTimeType.amPM, 'a', 1), 'PM');
      },
    );

    test(
      'when called, getDateFromRowIndex method should return correct value',
      () async {
        final date = DateTime(2024, 12, 31, 23, 59, 59);

        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.year,
            activeDate: date,
            rowIndex: 1,
          ),
          DateTime(2021, 12, 31, 23, 59, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.month,
            activeDate: date,
            rowIndex: 1,
          ),
          DateTime(2024, 2, 29, 23, 59, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.day,
            activeDate: date,
            rowIndex: 1,
          ),
          DateTime(2024, 12, 2, 23, 59, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.weekday,
            activeDate: date,
            rowIndex: 0,
          ),
          DateTime(2024, 12, 30, 23, 59, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.weekday,
            activeDate: date,
            rowIndex: 5,
          ),
          DateTime(2025, 1, 4, 23, 59, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.hour24,
            activeDate: date,
            rowIndex: 15,
          ),
          DateTime(2024, 12, 31, 15, 59, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.hour12,
            activeDate: date,
            rowIndex: 15,
          ),
          DateTime(2024, 12, 31, 16, 59, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.hour12,
            activeDate: date,
            rowIndex: 11,
          ),
          DateTime(2024, 12, 31, 12, 59, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.hour12,
            activeDate: DateTime(2024, 12, 31, 1, 59, 59),
            rowIndex: 11,
          ),
          DateTime(2024, 12, 31, 0, 59, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.minute,
            activeDate: date,
            rowIndex: 1,
          ),
          DateTime(2024, 12, 31, 23, 1, 59),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.second,
            activeDate: date,
            rowIndex: 1,
          ),
          DateTime(2024, 12, 31, 23, 59, 1),
        );
        expect(
          helper.getDateFromRowIndex(
            type: DateTimeType.amPM,
            activeDate: date,
            rowIndex: 0,
          ),
          DateTime(2024, 12, 31, 11, 59, 59),
        );
      },
    );

    test(
      'when called, isTextDisabled method should return correct value',
      () async {
        final date = DateTime(2024, 2, 28, 23, 59, 59);

        expect(helper.isTextDisabled(DateTimeType.year, date, 1), false);
        expect(helper.isTextDisabled(DateTimeType.month, date, 2), true);
        expect(helper.isTextDisabled(DateTimeType.day, date, 31), true);
        expect(helper.isTextDisabled(DateTimeType.weekday, date, 5), true);
        expect(helper.isTextDisabled(DateTimeType.hour24, date, 1), true);
        expect(helper.isTextDisabled(DateTimeType.hour12, date, 1), true);
        expect(helper.isTextDisabled(DateTimeType.minute, date, 1), true);
        expect(helper.isTextDisabled(DateTimeType.second, date, 1), true);
        expect(helper.isTextDisabled(DateTimeType.amPM, date, 0), true);
      },
    );

    group('layout helper methods', () {
      const noPrefixWidget = DateTimePickerPrefixWidget();
      const withYearPrefix = DateTimePickerPrefixWidget(year: Text('Year:'));

      test('hasPrefixWidget returns false when no prefix widgets are set', () {
        expect(helper.hasPrefixWidget(DateTimeType.year, noPrefixWidget), false);
        expect(helper.hasPrefixWidget(DateTimeType.month, noPrefixWidget), false);
      });

      test('hasPrefixWidget returns true only for types that have a widget', () {
        expect(helper.hasPrefixWidget(DateTimeType.year, withYearPrefix), true);
        expect(helper.hasPrefixWidget(DateTimeType.month, withYearPrefix), false);
      });

      test('getColumnFlex returns itemFlex when no prefix widget exists', () {
        // Default itemFlex is 1 for every type; no prefix widget → column flex == 1
        expect(helper.getColumnFlex(DateTimeType.year, noPrefixWidget), 1);
        expect(helper.getColumnFlex(DateTimeType.month, noPrefixWidget), 1);
      });

      test('getColumnFlex adds prefixFlex when a prefix widget exists', () {
        // Default itemFlex = 1, default prefixFlex = 1 → 1 + 1 = 2
        expect(helper.getColumnFlex(DateTimeType.year, withYearPrefix), 2);
        // Month has no prefix widget → still 1
        expect(helper.getColumnFlex(DateTimeType.month, withYearPrefix), 1);
      });

      test('getTotalFlex sums column flex values across all format types', () {
        // Format: 'yy-MMM-dd hh:mm:ss a' → year, month, day, hour12, minute, second, amPM (7 types)
        // No prefix widgets → total = 7 × 1 = 7
        expect(helper.getTotalFlex(noPrefixWidget), 7);

        // Year has prefix → year contributes 2, rest 1 each (6) → total = 8
        expect(helper.getTotalFlex(withYearPrefix), 8);
      });

      test('getPrefixWidth returns 0 when no prefix widget exists for type', () {
        expect(
          helper.getPrefixWidth(DateTimeType.year, noPrefixWidget, 400),
          0,
        );
      });

      test('getPrefixWidth returns correct fraction of container width', () {
        // Total flex with year prefix = 8 (see above). prefixFlex for year = 1.
        // Expected width = 400 * (1 / 8) = 50.0
        expect(
          helper.getPrefixWidth(DateTimeType.year, withYearPrefix, 400),
          400 * (1 / 8),
        );
      });

      test('getPrefixWidth with custom itemFlex and prefixFlex', () {
        final customHelper = DateTimePickerHelper(
          DateTimePickerOption(
            dateFormat: DateFormat('yy-MMM-dd hh:mm:ss a'),
            minDate: DateTime(2020, 6),
            maxDate: DateTime(2024, 1, 1, 23, 59, 59),
          ),
          const DateTimePickerItemFlex(yearFlex: 2),
          const DateTimePickerPrefixFlex(yearFlex: 3),
        );

        // Types: year(item=2,prefix=3), month(1), day(1), hour12(1), minute(1), second(1), amPM(1)
        // Total = (2+3) + 1 + 1 + 1 + 1 + 1 + 1 = 11
        expect(customHelper.getTotalFlex(withYearPrefix), 11);

        // prefixWidth = 800 * (3 / 11)
        expect(
          customHelper.getPrefixWidth(DateTimeType.year, withYearPrefix, 800),
          closeTo(800 * (3 / 11), 0.001),
        );
      });
    });
  });

  group('test int extension', () {
    test(
      'when called, isLeapYear getter should return correct value',
      () async {
        expect(2000.isLeapYear, true);
        expect(2020.isLeapYear, true);
        expect(2021.isLeapYear, false);
        expect(2022.isLeapYear, false);
        expect(2024.isLeapYear, true);
      },
    );
  });

  group('test DateTime extension', () {
    test(
      'when called, copyWith method should return correct value',
      () async {
        expect(
          DateTime(2020).copyWith(year: 2021),
          DateTime(2021),
        );
        expect(
          DateTime(2020, 2).copyWith(month: 3),
          DateTime(2020, 3),
        );
        expect(
          DateTime(2020, 2, 2).copyWith(day: 3),
          DateTime(2020, 2, 3),
        );
        expect(
          DateTime(2020, 2, 2).copyWith(hour: 3),
          DateTime(2020, 2, 2, 3),
        );
        expect(
          DateTime(2020, 2, 2).copyWith(minute: 3),
          DateTime(2020, 2, 2, 0, 3),
        );
        expect(
          DateTime(2020, 2, 2).copyWith(second: 3),
          DateTime(2020, 2, 2, 0, 0, 3),
        );
      },
    );
  });
}