import 'package:flutter_test/flutter_test.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';

void main() {
  group('test DateTimeType', () {
    test(
      'when called, basePattern getter should return correct value',
      () {
        expect(DateTimeType.year.basePattern, 'y');
        expect(DateTimeType.month.basePattern, 'M');
        expect(DateTimeType.day.basePattern, 'd');
        expect(DateTimeType.weekday.basePattern, 'E');
        expect(DateTimeType.hour24.basePattern, 'H');
        expect(DateTimeType.hour12.basePattern, 'h');
        expect(DateTimeType.minute.basePattern, 'm');
        expect(DateTimeType.second.basePattern, 's');
        expect(DateTimeType.amPM.basePattern, 'a');
      },
    );

    group('test fromPattern getter', () {
      test(
        'when called with known value, should return correct value',
        () {
          expect(DateTimeType.fromPattern('yy'), DateTimeType.year);
          expect(DateTimeType.fromPattern('MMM'), DateTimeType.month);
          expect(DateTimeType.fromPattern('dd'), DateTimeType.day);
          expect(DateTimeType.fromPattern('EEEE'), DateTimeType.weekday);
          expect(DateTimeType.fromPattern('HH'), DateTimeType.hour24);
          expect(DateTimeType.fromPattern('hh'), DateTimeType.hour12);
          expect(DateTimeType.fromPattern('mm'), DateTimeType.minute);
          expect(DateTimeType.fromPattern('ss'), DateTimeType.second);
          expect(DateTimeType.fromPattern('a'), DateTimeType.amPM);
          expect(DateTimeType.fromPattern('j'), DateTimeType.hour12);
          expect(DateTimeType.fromPattern('c'), DateTimeType.day);
          expect(DateTimeType.fromPattern('cc'), DateTimeType.day);
          expect(DateTimeType.fromPattern('ccc'), DateTimeType.weekday);
          expect(DateTimeType.fromPattern('cccc'), DateTimeType.weekday);
        },
      );
      test(
        'when called with unknown value, should throw exception',
        () => expect(() => DateTimeType.fromPattern('A'), throwsException),
      );
    });
  });
}
