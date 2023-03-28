part of 'scroll_date_picker.dart';

class _Helper {
  const _Helper(this.dateOption);
  final DatePickerOption dateOption;

  int get _numOfYear =>
      dateOption.getMaxDate.year - dateOption.getMinDate.year + 1;

  int maxDate(int month, int year) {
    switch (month) {
      case 1:
        return 31;
      case 2:
        return year.isLeapYear ? 29 : 28;
      case 3:
        return 31;
      case 4:
        return 30;
      case 5:
        return 31;
      case 6:
        return 30;
      case 7:
        return 31;
      case 8:
        return 31;
      case 9:
        return 30;
      case 10:
        return 31;
      case 11:
        return 30;
      case 12:
        return 31;

      default:
        return 0;
    }
  }

  List<int> get years => List.generate(
        _numOfYear,
        (index) => dateOption.getMinDate.year - 1 + index,
      );

  int itemCount(int index) {
    switch (index) {
      case 0:
        return 31;
      case 1:
        return 12;
      case 2:
        return _numOfYear;
      default:
        return 0;
    }
  }

  String getText(int colIndex, int rowIndex) {
    switch (colIndex) {
      case 0:
        return '${rowIndex + 1}';
      case 1:
        return DateFormat(
          'MMMM',
          dateOption.locale.languageCode,
        ).format(
          DateTime(2000, rowIndex + 1),
        );
      case 2:
        return '${years[rowIndex]}';
      default:
        return '-';
    }
  }
}

extension LeapYearX on int {
  bool get isLeapYear {
    if (this % 4 == 0) {
      if (this % 100 == 0) {
        if (this % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}
