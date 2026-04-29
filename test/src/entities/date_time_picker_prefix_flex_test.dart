import 'package:flutter_test/flutter_test.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';

void main() {
  group('DateTimePickerPrefixFlex Tests', () {
    test('should return correct flex width for each DateTimeType', () {
      // Create an instance with custom flex values for each DateTimeType
      const prefixFlex = DateTimePickerPrefixFlex(
        yearFlex: 2,
        monthFlex: 3,
        dayFlex: 4,
        weekdayFlex: 5,
        hour24Flex: 6,
        hour12Flex: 7,
        minuteFlex: 8,
        secondFlex: 9,
        amPMFlex: 10,
      );

      // Verify that the getFlex method returns the correct flex width for each DateTimeType
      expect(prefixFlex.getFlex(DateTimeType.year), 2);
      expect(prefixFlex.getFlex(DateTimeType.month), 3);
      expect(prefixFlex.getFlex(DateTimeType.day), 4);
      expect(prefixFlex.getFlex(DateTimeType.weekday), 5);
      expect(prefixFlex.getFlex(DateTimeType.hour24), 6);
      expect(prefixFlex.getFlex(DateTimeType.hour12), 7);
      expect(prefixFlex.getFlex(DateTimeType.minute), 8);
      expect(prefixFlex.getFlex(DateTimeType.second), 9);
      expect(prefixFlex.getFlex(DateTimeType.amPM), 10);
    });

    test('should return default flex width of 1 for each DateTimeType', () {
      // Create an instance with default flex values for each DateTimeType
      const prefixFlex = DateTimePickerPrefixFlex();

      // Verify that the getFlex method returns the default flex width of 1 for each DateTimeType
      expect(prefixFlex.getFlex(DateTimeType.year), 1);
      expect(prefixFlex.getFlex(DateTimeType.month), 1);
      expect(prefixFlex.getFlex(DateTimeType.day), 1);
      expect(prefixFlex.getFlex(DateTimeType.weekday), 1);
      expect(prefixFlex.getFlex(DateTimeType.hour24), 1);
      expect(prefixFlex.getFlex(DateTimeType.hour12), 1);
      expect(prefixFlex.getFlex(DateTimeType.minute), 1);
      expect(prefixFlex.getFlex(DateTimeType.second), 1);
      expect(prefixFlex.getFlex(DateTimeType.amPM), 1);
    });

    test('should correctly handle mixed custom and default flex values', () {
      // Create an instance with some custom flex values and leave others as default
      const prefixFlex = DateTimePickerPrefixFlex(
        yearFlex: 3,
        dayFlex: 2,
        hour24Flex: 4,
      );

      // Verify custom values are set correctly
      expect(prefixFlex.getFlex(DateTimeType.year), 3);
      expect(prefixFlex.getFlex(DateTimeType.day), 2);
      expect(prefixFlex.getFlex(DateTimeType.hour24), 4);

      // Verify default values remain for unspecified properties
      expect(prefixFlex.getFlex(DateTimeType.month), 1);
      expect(prefixFlex.getFlex(DateTimeType.weekday), 1);
      expect(prefixFlex.getFlex(DateTimeType.hour12), 1);
      expect(prefixFlex.getFlex(DateTimeType.minute), 1);
      expect(prefixFlex.getFlex(DateTimeType.second), 1);
      expect(prefixFlex.getFlex(DateTimeType.amPM), 1);
    });

    test(
        'should create an instance with all properties explicitly set to default values',
        () {
      // Create an instance with all properties explicitly set to the default value of 1
      const prefixFlex = DateTimePickerPrefixFlex(
        
      );

      // Verify all values are set to 1
      expect(prefixFlex.getFlex(DateTimeType.year), 1);
      expect(prefixFlex.getFlex(DateTimeType.month), 1);
      expect(prefixFlex.getFlex(DateTimeType.day), 1);
      expect(prefixFlex.getFlex(DateTimeType.weekday), 1);
      expect(prefixFlex.getFlex(DateTimeType.hour24), 1);
      expect(prefixFlex.getFlex(DateTimeType.hour12), 1);
      expect(prefixFlex.getFlex(DateTimeType.minute), 1);
      expect(prefixFlex.getFlex(DateTimeType.second), 1);
      expect(prefixFlex.getFlex(DateTimeType.amPM), 1);
    });
  });
}
