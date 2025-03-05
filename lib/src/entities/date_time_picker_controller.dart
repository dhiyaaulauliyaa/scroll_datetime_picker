part of '../scroll_date_time_picker.dart';

/// A data class representing the state of the datetime picker.
///
/// This class holds the currently selected date and time in the picker.
/// It is used by [DateTimePickerController] to manage the state.
class DateTimePickerData {
  const DateTimePickerData({
    this.activeDate,
  });

  final DateTime? activeDate;

  DateTimePickerData copyWith({DateTime? activeDate}) => DateTimePickerData(
        activeDate: activeDate ?? this.activeDate,
      );
}

/// A state manager for the datetime picker.
///
/// This class extends [ValueNotifier] to provide and manage the state of the datetime picker.
/// It notifies its listeners whenever the active date changes.
class DateTimePickerController extends ValueNotifier<DateTimePickerData> {
  DateTimePickerController() : super(const DateTimePickerData());

  /// Updates the active date in the state and notifies all listeners.
  ///
  /// This method has function to change the active date on the DateTime picker programmatically
  ///
  /// Throws:
  /// - [ArgumentError] if the provided [datetime] is null or invalid.
  /// - [Exception] if the provided [datetime] is outside the allowed range
  ///   (as defined by [DateTimePickerOption.minDate] and [DateTimePickerOption.maxDate]).
  void changeDateTime(DateTime datetime) {
    value = value.copyWith(activeDate: datetime);
    notifyListeners();
  }
}
