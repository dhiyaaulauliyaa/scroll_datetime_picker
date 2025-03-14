import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('DateTimePickerPrefixWidget', () {
    test('should create instance with default parameters', () {
      // Create an instance with default parameters
      const prefixWidget = DateTimePickerPrefixWidget();

      // Verify that all parameters are null by default
      expect(prefixWidget.year, isNull);
      expect(prefixWidget.month, isNull);
      expect(prefixWidget.day, isNull);
      expect(prefixWidget.weekday, isNull);
      expect(prefixWidget.hour24, isNull);
      expect(prefixWidget.hour12, isNull);
      expect(prefixWidget.minute, isNull);
      expect(prefixWidget.second, isNull);
      expect(prefixWidget.amPM, isNull);
      expect(prefixWidget.builder, isNull);
    });

    test('should create instance with custom parameters', () {
      // Create custom widgets
      const customYearWidget = Text('Year:');
      const customMonthWidget = Text('Month:');

      // Create an instance with custom parameters
      const prefixWidget = DateTimePickerPrefixWidget(
        year: customYearWidget,
        month: customMonthWidget,
      );

      // Verify that custom parameters are set correctly
      expect(prefixWidget.year, customYearWidget);
      expect(prefixWidget.month, customMonthWidget);
    });

    test('should build custom prefix widget using builder function', () {
      // Create a builder function
      Row customBuilder(
        BuildContext context,
        BoxConstraints constraints,
        Widget child,
      ) {
        return Row(
          children: [
            const Text('Custom Prefix Widget'),
            child,
          ],
        );
      }

      // Create an instance with a custom builder function
      final prefixWidget = DateTimePickerPrefixWidget(builder: customBuilder);

      // Create a child widget
      const childWidget = Text('Child');

      // Create a mock BuildContext and a default BoxConstraints
      final mockContext = MockBuildContext();
      const defaultConstraints = BoxConstraints();

      // Use the builder function to build the custom prefix widget
      final customPrefixWidget = prefixWidget.builder!(
        mockContext,
        defaultConstraints,
        childWidget,
      );

      // Verify that the custom prefix widget is built correctly
      expect(customPrefixWidget, isA<Row>());
      expect((customPrefixWidget as Row).children, hasLength(2));
      expect(customPrefixWidget.children[0], isA<Text>());
      expect(
        (customPrefixWidget.children[0] as Text).data,
        'Custom Prefix Widget',
      );
      expect(customPrefixWidget.children[1], childWidget);
    });

    test('should return correct prefix widget for specified DateTimeType', () {
      // Create custom widgets
      const customYearWidget = Text('Year:');
      const customMonthWidget = Text('Month:');
      const customDayWidget = Text('Day:');
      const customWeekdayWidget = Text('Weekday:');
      const customHour24Widget = Text('24 Hour:');
      const customHour12Widget = Text('12 Hour:');
      const customMinuteWidget = Text('Minute:');
      const customSecondWidget = Text('Second:');
      const customAmPMWidget = Text('AM/PM:');

      // Create an instance with custom parameters for all DateTimeTypes
      const prefixWidget = DateTimePickerPrefixWidget(
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

      // Verify that the correct prefix widget is returned for each DateTimeType
      expect(
        prefixWidget.getPrefixWidget(DateTimeType.year),
        customYearWidget,
      );
      expect(
        prefixWidget.getPrefixWidget(DateTimeType.month),
        customMonthWidget,
      );
      expect(
        prefixWidget.getPrefixWidget(DateTimeType.day),
        customDayWidget,
      );
      expect(
        prefixWidget.getPrefixWidget(DateTimeType.weekday),
        customWeekdayWidget,
      );
      expect(
        prefixWidget.getPrefixWidget(DateTimeType.hour24),
        customHour24Widget,
      );
      expect(
        prefixWidget.getPrefixWidget(DateTimeType.hour12),
        customHour12Widget,
      );
      expect(
        prefixWidget.getPrefixWidget(DateTimeType.minute),
        customMinuteWidget,
      );
      expect(
        prefixWidget.getPrefixWidget(DateTimeType.second),
        customSecondWidget,
      );
      expect(
        prefixWidget.getPrefixWidget(DateTimeType.amPM),
        customAmPMWidget,
      );
    });

    test('should return correct value for hasTypeSpecificPrefixWidgets', () {
      // Create custom widgets
      const customYearWidget = Text('Year:');
      const customMonthWidget = Text('Month:');

      // Create an instance with custom parameters for all DateTimeTypes
      const prefixWidgetEmpty = DateTimePickerPrefixWidget();
      const prefixWidgetWithWidgets = DateTimePickerPrefixWidget(
        year: customYearWidget,
        month: customMonthWidget,
      );

      // Verify that hasTypeSpecificPrefixWidgets is false when no widgets are set
      expect(prefixWidgetEmpty.hasTypeSpecificPrefixWidgets, isFalse);

      // Verify that hasTypeSpecificPrefixWidgets is true when at least one widget is set
      expect(prefixWidgetWithWidgets.hasTypeSpecificPrefixWidgets, isTrue);
    });

    test('should correctly count the number of set widgets', () {
      // Create custom widgets for testing
      const customWidget = Text('Test');

      // Test various combinations of set widgets
      const emptyPrefixWidget = DateTimePickerPrefixWidget();
      expect(emptyPrefixWidget.countSetWidgets(), 0);

      const oneWidgetSet = DateTimePickerPrefixWidget(year: customWidget);
      expect(oneWidgetSet.countSetWidgets(), 1);

      const twoWidgetsSet = DateTimePickerPrefixWidget(
        year: customWidget,
        month: customWidget,
      );
      expect(twoWidgetsSet.countSetWidgets(), 2);

      const allWidgetsSet = DateTimePickerPrefixWidget(
        year: customWidget,
        month: customWidget,
        day: customWidget,
        weekday: customWidget,
        hour24: customWidget,
        hour12: customWidget,
        minute: customWidget,
        second: customWidget,
        amPM: customWidget,
      );
      expect(allWidgetsSet.countSetWidgets(), 9);
    });
  });
}
