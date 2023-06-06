part of 'scroll_date_picker.dart';

class DatePickerOption {
  const DatePickerOption({
    this.minDate,
    this.maxDate,
    this.initialDate,
    this.locale = const Locale('en', 'US'),
  });

  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? initialDate;
  final Locale locale;

  DateTime get getMinDate => minDate ?? DateTime(DateTime.now().year - 1);
  DateTime get getMaxDate => maxDate ?? DateTime(DateTime.now().year + 1);
  DateTime get getInitialDate => initialDate ?? DateTime.now();
}
