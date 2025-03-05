import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/src/entities/date_time_picker_helper.dart';
import 'package:scroll_datetime_picker/src/entities/enums.dart';
import 'package:scroll_datetime_picker/src/widgets/picker_widget.dart';

part 'entities/date_time_picker_option.dart';
part 'entities/date_time_picker_style.dart';
part 'entities/date_time_picker_wheel_option.dart';
part 'entities/date_time_picker_item_flex.dart';
part 'entities/date_time_picker_center_widget.dart';
part 'entities/date_time_picker_controller.dart';

typedef DateTimePickerItemBuilder = Widget Function(
  BuildContext context,
  String pattern,
  String text,
  bool isActive,
  bool isDisabled,
);

/// A customizable Scrollable DateTimePicker.
///
/// To set a custom datetime format, use DateFormat available in
/// `[dateOption]` param
///
/// To set styles for the picker, use `[style]` param
class ScrollDateTimePicker extends StatefulWidget {
  const ScrollDateTimePicker({
    super.key,
    required this.itemExtent,
    required this.dateOption,
    required this.onChange,
    this.controller,
    this.itemBuilder,
    this.style,
    this.visibleItem = 3,
    this.infiniteScroll = false,
    this.markOutOfRangeDateInvalid = true,
    this.itemFlex = const DateTimePickerItemFlex(),
    this.wheelOption = const DateTimePickerWheelOption(),
    this.centerWidget = const DateTimePickerCenterWidget(),
  });

  /// Optional controller for managing the picker's state.
  ///
  /// This can be used to programmatically update the selected date/time.
  final DateTimePickerController? controller;

  /// Height of every item in the picker
  ///
  /// Must not be null
  final double itemExtent;

  /// Number of item to be shown vertically
  ///
  /// Defaults to 3
  final int visibleItem;

  /// Whether to implement infinite scroll or finite scroll.
  ///
  /// Defaults to false
  final bool infiniteScroll;

  /// Callback called when the selected date and/or time changes.
  ///
  /// Must not be null.
  final void Function(DateTime datetime)? onChange;

  /// Set datetime configuration
  ///
  /// Must not be null.
  final DateTimePickerOption dateOption;

  /// Set picker styles.
  ///
  /// If [itemBuilder] is not null, this value will be omitted.
  final DateTimePickerStyle? style;

  /// Set custom appearance for the picker wheel
  ///
  /// The parameters here are based on flutter's [ListWheelScrollView]
  final DateTimePickerWheelOption wheelOption;

  /// Set custom appearance for every item in the picker wheel
  ///
  /// - If null, the appearance of every item will be based on DateTimePickerStyle [style]
  /// - If not null, the appearance of every item will be based return value of this builder
  final DateTimePickerItemBuilder? itemBuilder;

  /// Custom flex width settings for each date and time item in the picker wheel.
  ///
  /// This parameter allows you to specify different flex widths for each date and time item,
  /// such as year, month, day, hour, minute, and second, allowing for a more flexible and
  /// visually appealing layout.
  ///
  /// Defaults to `const DateTimePickerItemFlex()` with all values set to 1.
  final DateTimePickerItemFlex itemFlex;

  /// Custom center widget settings for each date and time item in the picker wheel.
  ///
  /// This parameter allows you to specify custom center widgets for each date and
  /// time item, such as year, month, day, hour, minute, and second, allowing for
  /// a more customizable layout. You can set different widgets for each
  /// date and time type or use a custom builder to customize the appearance
  /// of the center area in the picker.
  ///
  /// - If not set, the center widget will be a default layout with no customization.
  /// - Use the individual widget parameters in `DateTimePickerCenterWidget` to specify
  ///   custom widgets for each date and time type.
  final DateTimePickerCenterWidget centerWidget;

  /// Whether to mark out-of-range dates as invalid.
  ///
  /// If set to true, dates before the minimum date and after the maximum date
  /// will be considered invalid selections, and the user will not be able
  /// to choose them. If set to false, the user can still select out-of-range
  /// dates.
  final bool markOutOfRangeDateInvalid;

  @override
  State<ScrollDateTimePicker> createState() => _ScrollDateTimePickerState();
}

class _ScrollDateTimePickerState extends State<ScrollDateTimePicker> {
  late final ValueNotifier<DateTime> _activeDate;
  late List<ScrollController> _controllers;

  late DateTimePickerStyle _style;
  late DateTimePickerOption _option;
  late DateTimePickerHelper _helper;

  late final ValueNotifier<bool> _isRecheckingPosition;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting(widget.dateOption.locale.languageCode);
    _isRecheckingPosition = ValueNotifier(false);

    _option = widget.dateOption;
    _activeDate = ValueNotifier<DateTime>(_option.getInitialDate);
    _helper = DateTimePickerHelper(_option);
    _style = widget.style ?? DateTimePickerStyle();
    _controllers = List.generate(
      _option.patterns.length,
      (index) => ScrollController(),
    );

    /* Init controller */
    if (widget.controller != null) {
      widget.controller?.addListener(() async {
        if (widget.controller?.value.activeDate == null) return;
        return _driveDatePosition(widget.controller!.value.activeDate!);
      });
    }

    /* Init date position */
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => _driveDatePosition(_option.getInitialDate),
    );
  }

  @override
  void didUpdateWidget(covariant ScrollDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.dateOption != _option) {
      setState(() {
        _option = widget.dateOption;
        _helper = DateTimePickerHelper(_option);

        if (_option.patterns.length != _controllers.length) {
          final difference = _option.patterns.length - _controllers.length;
          if (difference.isNegative) {
            _controllers.removeRange(
              _controllers.length - difference.abs(),
              _controllers.length,
            );
          } else {
            _controllers.addAll(
              List.generate(
                difference,
                (_) => ScrollController(),
              ),
            );
          }
        }
      });
    }

    if (widget.style != _style) {
      setState(() {
        _style = widget.style ?? _style;
      });
    }
  }

  @override
  void dispose() {
    _isRecheckingPosition.dispose();
    _activeDate.dispose();

    for (final ctrl in _controllers) {
      ctrl.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth,
        height: widget.itemExtent * widget.visibleItem,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /* Center Decoration */
            SizedBox(
              height: widget.itemExtent,
              width: constraints.maxWidth,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final child = widget.centerWidget.hasTypeSpecificCenterWidgets
                      ? Row(
                          children: List.generate(
                            _option.patterns.length,
                            (colIndex) {
                              final pattern = _option.patterns[colIndex];
                              final type = DateTimeType.fromPattern(pattern);

                              return Expanded(
                                flex: widget.itemFlex.getFlex(type),
                                child:
                                    widget.centerWidget.getCenterWidget(type) ??
                                        const SizedBox(),
                              );
                            },
                          ),
                        )
                      : const SizedBox();

                  return widget.centerWidget.builder
                          ?.call(context, constraints, child) ??
                      child;
                },
              ),
            ),

            /* Picker Widget */
            SizedBox(
              width: constraints.maxWidth,
              height: widget.itemExtent * widget.visibleItem,
              child: Row(
                children: List.generate(
                  _option.patterns.length,
                  (colIndex) {
                    final pattern = _option.patterns[colIndex];
                    final type = DateTimeType.fromPattern(pattern);

                    return Expanded(
                      flex: widget.itemFlex.getFlex(type),
                      child: PickerWidget(
                        itemExtent: widget.itemExtent,
                        infiniteScroll: widget.infiniteScroll,
                        controller: _controllers[colIndex],
                        onChange: (rowIndex) => _onChange(type, rowIndex),
                        itemCount: _helper.itemCount(type),
                        wheelOption: widget.wheelOption,
                        inactiveBuilder: (rowIndex) {
                          final text = _helper.getText(type, pattern, rowIndex);
                          final isDisabled = _helper.isTextDisabled(
                            type,
                            _activeDate.value,
                            rowIndex,
                          );

                          return widget.itemBuilder != null
                              ? widget.itemBuilder!(
                                  context,
                                  pattern,
                                  text,
                                  false,
                                  isDisabled,
                                )
                              : Container(
                                  width: constraints.maxWidth,
                                  height: widget.itemExtent,
                                  alignment: Alignment.center,
                                  decoration: _style.inactiveDecoration,
                                  child: Text(
                                    text,
                                    style: isDisabled
                                        ? _style.disabledStyle
                                        : _style.inactiveStyle,
                                  ),
                                );
                        },
                        activeBuilder: (rowIndex) {
                          final text = _helper.getText(type, pattern, rowIndex);
                          final isDisabled = _helper.isTextDisabled(
                            type,
                            _activeDate.value,
                            rowIndex,
                          );

                          return widget.itemBuilder != null
                              ? widget.itemBuilder!(
                                  context,
                                  pattern,
                                  text,
                                  true,
                                  isDisabled,
                                )
                              : Container(
                                  width: constraints.maxWidth,
                                  height: widget.itemExtent,
                                  alignment: Alignment.center,
                                  decoration: _style.activeDecoration,
                                  child: Text(
                                    text,
                                    style: isDisabled
                                        ? _style.disabledStyle
                                        : _style.activeStyle,
                                  ),
                                );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _driveDatePosition(DateTime targetDate) async {
    /* 1. If target date already same, return */
    if (targetDate == _activeDate.value) return;

    /* 2. If target date out of range, return */
    if (_isDateOutOfRange(targetDate)) throw Exception('Date is Out of Range');

    /* 3. Ensure the active date is updated before driving the scroll position */
    _activeDate.value = targetDate;

    /* 4. Start drive date position */
    for (var i = 0; i < _option.dateTimeTypes.length; i++) {
      late double extent;

      switch (_option.dateTimeTypes[i]) {
        case DateTimeType.year:
          extent = _helper.years.indexOf(targetDate.year).toDouble();
          break;
        case DateTimeType.month:
          extent = targetDate.month - 1;
          break;
        case DateTimeType.day:
          extent = targetDate.day - 1;
          break;
        case DateTimeType.weekday:
          extent = targetDate.weekday - 1;
          break;
        case DateTimeType.hour24:
          extent = targetDate.hour - 1;
          break;
        case DateTimeType.hour12:
          extent = _helper.convertToHour12(targetDate.hour) - 1;
          break;
        case DateTimeType.minute:
          extent = targetDate.minute.toDouble();
          break;
        case DateTimeType.second:
          extent = targetDate.second.toDouble();
          break;
        case DateTimeType.amPM:
          extent = _helper.isAM(targetDate.hour) ? 0 : 1;
          break;
      }

      /* 4.1. If controller doesn't attached to any client, return */
      if (!_controllers[i].hasClients) continue;

      /* 4.2. Animate to position */
      unawaited(
        _controllers[i].animateTo(
          widget.itemExtent * extent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        ),
      );

      /* 4.3. Await to prevent race conditions */
      await Future.microtask(() => null);
    }
  }

  bool _isDateOutOfRange(DateTime date) {
    if (date.isAfter(_option.maxDate)) return true;
    if (date.isBefore(_option.minDate)) return true;

    return false;
  }

  Future<void> _onChange(DateTimeType type, int rowIndex) async {
    if (!mounted) return;

    /* 1. Calculate new date based on rowIndex */
    var newDate = _helper.getDateFromRowIndex(
      type: type,
      rowIndex: rowIndex,
      activeDate: _activeDate.value,
    );

    /* 2. If date out of range, change target date to be existing date */
    if (widget.markOutOfRangeDateInvalid) {
      if (_isDateOutOfRange(newDate)) newDate = _activeDate.value;
    }

    /* 3. Refresh state to update widget styling */
    if (newDate != _activeDate.value && mounted) setState(() {});

    /* 4. Set the new date */
    _activeDate.value = newDate;
    widget.onChange?.call(newDate);

    /* 5. Recheck scroll positions, should be stopped at correct position */
    if (!_isRecheckingPosition.value) {
      _isRecheckingPosition.value = true;
      await _recheckPosition(DateTimeType.year, newDate);
      await _recheckPosition(DateTimeType.month, newDate);
      await _recheckPosition(DateTimeType.day, newDate);
      await _recheckPosition(DateTimeType.weekday, newDate);
      if (mounted) _isRecheckingPosition.value = false;
    }

    return;
  }

  Future<void> _recheckPosition(DateTimeType type, DateTime date) async {
    final index = _option.dateTimeTypes.indexOf(type);
    if (index != -1) {
      late int targetPosition;

      switch (type) {
        case DateTimeType.year:
          targetPosition = _helper.years.indexOf(date.year) + 1;
          break;
        case DateTimeType.month:
          targetPosition = date.month;
          break;
        case DateTimeType.day:
          targetPosition = date.day;
          break;
        case DateTimeType.weekday:
          targetPosition = date.weekday;
          break;
        default:
          break;
      }

      /* Check if other scroll controller is still scrolling */
      await _fixPosition(
        controller: _controllers[index],
        itemCount: _helper.itemCount(type),
        targetPosition: targetPosition,
      );
    }
  }

  Future<void> _fixPosition({
    required ScrollController controller,
    required int itemCount,
    required int targetPosition,
  }) async {
    if (!mounted) return;

    /* 1. If doesn't have controller, return */
    if (!controller.hasClients) return;

    /* 2. If existing postition already same with target, return */
    final scrollPosition =
        (controller.offset / widget.itemExtent).floor() % itemCount + 1;
    if (targetPosition == scrollPosition) return;

    /* 3. If still scrolling, return */
    if (controller.position.isScrollingNotifier.value) return;

    /* 4. Calculate the difference */
    final difference = scrollPosition - targetPosition;
    final endOffset = controller.offset - (difference * widget.itemExtent);

    /* 5. Start fixing position */

    await Future.delayed(
      const Duration(milliseconds: 100),
      () => controller.animateTo(
        endOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceOut,
      ),
    );

    return;
  }
}
