import 'package:flutter_test/flutter_test.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart'; // Adjust import path as needed

void main() {
  group('DateTimePickerController', () {
    test('should initialize with null activeDate', () {
      final controller = DateTimePickerController();

      expect(controller.value.activeDate, isNull);
    });

    test('should update activeDate when changeDateTime is called', () {
      final controller = DateTimePickerController();
      final testDate = DateTime(2023, 5, 15);

      controller.changeDateTime(testDate);

      expect(controller.value.activeDate, testDate);
    });

    test('should notify listeners only when activeDate changes', () {
      final controller = DateTimePickerController();
      final testDate = DateTime(2023, 5, 15);

      var listenerCallCount = 0;

      controller
        ..addListener(() => listenerCallCount++) // Track listener calls
        ..changeDateTime(testDate); // Change to a new date
      expect(listenerCallCount, 1);

      // Try to change to the same date again
      controller.changeDateTime(testDate);
      expect(
        listenerCallCount,
        1,
        reason: 'Listeners should not be notified if date is the same',
      );

      // Change to a different date
      controller.changeDateTime(testDate.add(const Duration(days: 1)));
      expect(listenerCallCount, 2);
    });

    test('should create a new DateTimePickerData with copyWith', () {
      final originalData = DateTimePickerData(
        activeDate: DateTime(2023, 5, 15),
      );
      final newDate = DateTime(2023, 6, 20);

      final updatedData = originalData.copyWith(activeDate: newDate);

      expect(updatedData.activeDate, newDate);
    });

    test(
      'should use original activeDate if no new date is provided in copyWith',
      () {
        final originalDate = DateTime(2023, 5, 15);
        final originalData = DateTimePickerData(activeDate: originalDate);

        final updatedData = originalData.copyWith();

        expect(updatedData.activeDate, originalDate);
      },
    );

    test('should handle multiple rapid date changes', () {
      final controller = DateTimePickerController();

      final dates = [
        DateTime(2023, 5, 15),
        DateTime(2023, 6, 20),
        DateTime(2023, 7, 25),
      ];

      // Track listener calls
      final capturedDates = <DateTime>[];
      controller.addListener(() {
        capturedDates.add(controller.value.activeDate!);
      });

      // Change dates rapidly
      for (final date in dates) {
        controller.changeDateTime(date);
      }

      // Verify all dates were captured
      expect(capturedDates, dates);

      // Verify final date
      expect(controller.value.activeDate, dates.last);
    });

    test('should handle null activeDate in copyWith', () {
      final originalData = DateTimePickerData(
        activeDate: DateTime(2023, 5, 15),
      );

      final updatedData = originalData.copyWith();

      expect(
        updatedData.activeDate,
        DateTime(2023, 5, 15),
      );
    });
  });
}
