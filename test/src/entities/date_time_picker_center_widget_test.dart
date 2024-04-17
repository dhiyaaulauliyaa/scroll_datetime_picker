import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('DateTimePickerCenterWidget', () {
    test('should create instance with default parameters', () {
      // Create an instance with default parameters
      const centerWidget = DateTimePickerCenterWidget();

      // Verify that all parameters are null by default
      expect(centerWidget.year, isNull);
      expect(centerWidget.month, isNull);
      expect(centerWidget.day, isNull);
      expect(centerWidget.weekday, isNull);
      expect(centerWidget.hour24, isNull);
      expect(centerWidget.hour12, isNull);
      expect(centerWidget.minute, isNull);
      expect(centerWidget.second, isNull);
      expect(centerWidget.amPM, isNull);
      expect(centerWidget.builder, isNull);
    });

    test('should create instance with custom parameters', () {
      // Create custom widgets
      const customYearWidget = Text('Year');
      const customMonthWidget = Text('Month');

      // Create an instance with custom parameters
      const centerWidget = DateTimePickerCenterWidget(
        year: customYearWidget,
        month: customMonthWidget,
      );

      // Verify that custom parameters are set correctly
      expect(centerWidget.year, customYearWidget);
      expect(centerWidget.month, customMonthWidget);
    });

    test('should build custom center widget using builder function', () {
      // Create a builder function
      Column customBuilder(
        BuildContext context,
        BoxConstraints constraints,
        Widget child,
      ) {
        return Column(
          children: [
            const Text('Custom Center Widget'),
            child,
          ],
        );
      }

      // Create an instance with a custom builder function
      final centerWidget = DateTimePickerCenterWidget(builder: customBuilder);

      // Create a child widget
      const childWidget = Text('Child');

      // Create a mock BuildContext and a default BoxConstraints
      final mockContext = MockBuildContext();
      const defaultConstraints = BoxConstraints();

      // Use the builder function to build the custom center widget
      final customCenterWidget = centerWidget.builder!(
        mockContext,
        defaultConstraints,
        childWidget,
      );

      // Verify that the custom center widget is built correctly
      expect(customCenterWidget, isA<Column>());
      expect((customCenterWidget as Column).children, hasLength(2));
      expect(customCenterWidget.children[0], isA<Text>());
      expect(
        (customCenterWidget.children[0] as Text).data,
        'Custom Center Widget',
      );
      expect(customCenterWidget.children[1], childWidget);
    });
    test('should return correct center widget for specified DateTimeType', () {
      // Create custom widgets
      const customYearWidget = Text('Year');
      const customMonthWidget = Text('Month');
      const customDayWidget = Text('Day');
      const customWeekdayWidget = Text('Weekday');
      const customHour24Widget = Text('24 Hour');
      const customHour12Widget = Text('12 Hour');
      const customMinuteWidget = Text('Minute');
      const customSecondWidget = Text('Second');
      const customAmPMWidget = Text('AM/PM');

      // Create an instance with custom parameters for all DateTimeTypes
      const centerWidget = DateTimePickerCenterWidget(
        year: customYearWidget,
        month: customMonthWidget,
        day: customDayWidget,
        weekday: customWeekdayWidget,
        hour24: customHour24Widget,
        hour12: customHour12Widget,
        minute: customMinuteWidget,
        second: customSecondWidget,
        amPM: customAmPMWidget,
      );

      // Verify that the correct center widget is returned for each DateTimeType
      expect(
        centerWidget.getCenterWidget(DateTimeType.year),
        customYearWidget,
      );
      expect(
        centerWidget.getCenterWidget(DateTimeType.month),
        customMonthWidget,
      );
      expect(
        centerWidget.getCenterWidget(DateTimeType.day),
        customDayWidget,
      );
      expect(
        centerWidget.getCenterWidget(DateTimeType.weekday),
        customWeekdayWidget,
      );
      expect(
        centerWidget.getCenterWidget(DateTimeType.hour24),
        customHour24Widget,
      );
      expect(
        centerWidget.getCenterWidget(DateTimeType.hour12),
        customHour12Widget,
      );
      expect(
        centerWidget.getCenterWidget(DateTimeType.minute),
        customMinuteWidget,
      );
      expect(
        centerWidget.getCenterWidget(DateTimeType.second),
        customSecondWidget,
      );
      expect(centerWidget.getCenterWidget(DateTimeType.amPM), customAmPMWidget);
    });

    test('should return correct value for hasTypeSpecificCenterWidgets', () {
      // Create custom widgets
      const customYearWidget = Text('Year');
      const customMonthWidget = Text('Month');
      const customDayWidget = Text('Day');
      const customWeekdayWidget = Text('Weekday');
      const customHour24Widget = Text('24 Hour');
      const customHour12Widget = Text('12 Hour');
      const customMinuteWidget = Text('Minute');
      const customSecondWidget = Text('Second');
      const customAmPMWidget = Text('AM/PM');

      // Create an instance with custom parameters for all DateTimeTypes
      const centerWidget = DateTimePickerCenterWidget(
        year: customYearWidget,
        month: customMonthWidget,
        day: customDayWidget,
        weekday: customWeekdayWidget,
        hour24: customHour24Widget,
        hour12: customHour12Widget,
        minute: customMinuteWidget,
        second: customSecondWidget,
        amPM: customAmPMWidget,
      );

      // Verify that hasTypeSpecificCenterWidgets is true when all custom widgets are set
      expect(centerWidget.hasTypeSpecificCenterWidgets, isTrue);
    });
  });
}
