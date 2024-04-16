import 'package:flutter_test/flutter_test.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';

void main() {
  group('DateTimePickerItemFlexX Tests', () {
    test('should return correct flex width for each DateTimeType', () {
      // Create an instance with custom flex values for each DateTimeType
      const itemFlex = DateTimePickerItemFlex(
        yearFlex: 2,
        monthFlex: 3,
        dayFlex: 4,
        weekdayFlex: 2,
        hour24Flex: 5,
        hour12Flex: 6,
        minuteFlex: 7,
        secondFlex: 8,
        amPMFlex: 9,
      );

      // Verify that the getFlex method returns the correct flex width for each DateTimeType
      expect(itemFlex.getFlex(DateTimeType.year), 2);
      expect(itemFlex.getFlex(DateTimeType.month), 3);
      expect(itemFlex.getFlex(DateTimeType.day), 4);
      expect(itemFlex.getFlex(DateTimeType.weekday), 2);
      expect(itemFlex.getFlex(DateTimeType.hour24), 5);
      expect(itemFlex.getFlex(DateTimeType.hour12), 6);
      expect(itemFlex.getFlex(DateTimeType.minute), 7);
      expect(itemFlex.getFlex(DateTimeType.second), 8);
      expect(itemFlex.getFlex(DateTimeType.amPM), 9);
    });

    test('should return default flex width of 1 for each DateTimeType', () {
      // Create an instance with default flex values for each DateTimeType
      const itemFlex = DateTimePickerItemFlex();

      // Verify that the getFlex method returns the default flex width of 1 for each DateTimeType
      expect(itemFlex.getFlex(DateTimeType.year), 1);
      expect(itemFlex.getFlex(DateTimeType.month), 1);
      expect(itemFlex.getFlex(DateTimeType.day), 1);
      expect(itemFlex.getFlex(DateTimeType.weekday), 1);
      expect(itemFlex.getFlex(DateTimeType.hour24), 1);
      expect(itemFlex.getFlex(DateTimeType.hour12), 1);
      expect(itemFlex.getFlex(DateTimeType.minute), 1);
      expect(itemFlex.getFlex(DateTimeType.second), 1);
      expect(itemFlex.getFlex(DateTimeType.amPM), 1);
    });
  });
}
