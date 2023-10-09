import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';
import 'package:scroll_datetime_picker/src/scroll_date_time_picker.dart';

void main() {
  final dateFormat = DateFormat('yy-MMM-dd-EEEE hh:mm:ss a', 'en_US');
  final option = DateTimePickerOption(
    dateFormat: dateFormat,
    minDate: DateTime(2020, 6),
    maxDate: DateTime(2024, 1, 1, 23, 59, 59),
  );

  group('test DateTimePickerOption', () {
    final dateFormat = DateFormat('yy-MMM-dd hh:mm:ss a', 'en_US');
    final option = DateTimePickerOption(
      dateFormat: dateFormat,
      minDate: DateTime(2020, 6),
      maxDate: DateTime(2024, 1, 1, 23, 59, 59),
    );

    test(
      'when called, locale getter should return correct value',
      () => expect(option.locale.languageCode, 'en_US'),
    );

    group('test initialDate getter', () {
      test(
        'when initialDate is not null, should return initial date from option',
        () {
          final option = DateTimePickerOption(
            dateFormat: dateFormat,
            minDate: DateTime(2020, 6),
            maxDate: DateTime(2024, 1, 1, 23, 59, 59),
            initialDate: DateTime(2023),
          );

          expect(option.getInitialDate, DateTime(2023));
        },
      );
      test(
        'when initialDate is null, should return DateTime.now()',
        () {
          final now = DateTime.now();

          expect(option.getInitialDate.year, now.year);
          expect(option.getInitialDate.month, now.month);
          expect(option.getInitialDate.day, now.day);
          expect(option.getInitialDate.hour, now.hour);
          expect(option.getInitialDate.minute, now.minute);
          expect(option.getInitialDate.second, now.second);
        },
      );
    });
  });
  group('test DateTimePickerOption extension', () {
    test(
      'when called, dateTimeTypes getter should return correct value',
      () => expect(
        option.dateTimeTypes,
        [
          DateTimeType.year,
          DateTimeType.month,
          DateTimeType.day,
          DateTimeType.weekday,
          DateTimeType.hour12,
          DateTimeType.minute,
          DateTimeType.second,
          DateTimeType.amPM,
        ],
      ),
    );

    group('test patterns getter', () {
      test(
        "when pattern from dateFormat isn't null, should return correct value",
        () {
          expect(
            option.patterns,
            ['yy', 'MMM', 'dd', 'EEEE', 'hh', 'mm', 'ss', 'a'],
          );
        },
      );
      test(
        'when pattern from dateFormat is null, should throws exception',
        () => expect(
          () => DateTimePickerOption(
            dateFormat: DateFormat(),
            minDate: option.minDate,
            maxDate: option.maxDate,
            initialDate: option.initialDate,
          ).patterns,
          throwsException,
        ),
      );
    });
  });
}
