import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

part 'entities/enums.dart';
part 'entities/date_picker_helper.dart';
part 'entities/date_time_picker_option.dart';
part 'entities/date_time_picker_style.dart';

part 'widgets/picker_widget.dart';
part 'widgets/scroll_type_listener.dart';

class ScrollDateTimePicker extends StatefulWidget {
  const ScrollDateTimePicker({
    super.key,
    required this.itemExtent,
    required this.dateOption,
    this.style,
    this.onChange,
    this.visibleItem = 3,
    this.infiniteScroll = true,
  });

  final double itemExtent;
  final int visibleItem;
  final bool infiniteScroll;

  final void Function(DateTime datetime)? onChange;

  final DateTimePickerOption dateOption;
  final DateTimePickerStyle? style;

  @override
  State<ScrollDateTimePicker> createState() => _ScrollDateTimePickerState();
}

class _ScrollDateTimePickerState extends State<ScrollDateTimePicker> {
  late final List<ScrollController> _controllers;
  late final ValueNotifier<DateTime> _activeDate;

  late final DateTimePickerStyle _style;
  late final DateTimePickerOption _option;
  late _Helper _helper;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting(widget.dateOption.locale.languageCode);

    _option = widget.dateOption;
    _activeDate = ValueNotifier<DateTime>(_option.getInitialDate);
    _helper = _Helper(_option);
    _style = widget.style ?? DateTimePickerStyle();
    _controllers = List.generate(
      _option.patterns.length,
      (index) => ScrollController(),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initDate();
    });
  }

  @override
  void dispose() {
    _activeDate.dispose();
    for (final ctrl in _controllers) {
      ctrl.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.itemExtent * widget.visibleItem,
      child: Row(
        children: List.generate(
          _option.patterns.length,
          (colIndex) {
            final pattern = _option.patterns[colIndex];
            final type = _DateTimeType.fromPattern(pattern);

            return Expanded(
              child: _PickerWidget(
                itemExtent: widget.itemExtent,
                infiniteScroll: widget.infiniteScroll,
                controller: _controllers[colIndex],
                onChange: (rowIndex) => _onChange(type, rowIndex),
                itemCount: _helper.itemCount(type),
                centerWidget: Container(
                  height: widget.itemExtent,
                  width: double.infinity,
                  decoration: _style.centerDecoration,
                ),
                inactiveBuilder: (rowIndex) => Text(
                  _helper.getText(
                    type,
                    pattern,
                    rowIndex % _helper.itemCount(type),
                  ),
                  style: _helper.isTextDisabled(
                    type,
                    _activeDate.value,
                    rowIndex,
                  )
                      ? _style.disabledStyle
                      : _style.inactiveStyle,
                ),
                activeBuilder: (rowIndex) {
                  return Text(
                    _helper.getText(
                      type,
                      pattern,
                      rowIndex % _helper.itemCount(type),
                    ),
                    style: _helper.isTextDisabled(
                      type,
                      _activeDate.value,
                      rowIndex,
                    )
                        ? _style.disabledStyle
                        : _style.activeStyle,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _initDate() {
    final activeDate = _activeDate.value;

    for (var i = 0; i < _option.dateTimeTypes.length; i++) {
      late double extent;

      switch (_option.dateTimeTypes[i]) {
        case _DateTimeType.year:
          extent = (_helper.years.indexOf(activeDate.year)).toDouble();
          break;
        case _DateTimeType.month:
          extent = activeDate.month - 1;
          break;
        case _DateTimeType.day:
          extent = activeDate.day - 1;
          break;
        case _DateTimeType.weekday:
          extent = activeDate.weekday - 1;
          break;
        case _DateTimeType.hour24:
          extent = activeDate.hour - 1;
          break;
        case _DateTimeType.hour12:
          extent = _helper.convertToHour12(activeDate.hour) - 1;
          break;
        case _DateTimeType.minute:
          extent = activeDate.minute.toDouble();
          break;
        case _DateTimeType.second:
          extent = activeDate.second.toDouble();
          break;
        case _DateTimeType.amPM:
          extent = _helper.isAM(activeDate.hour) ? 0 : 1;
          break;
      }

      _controllers[i].animateTo(
        widget.itemExtent * extent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  void _onChange(_DateTimeType type, int rowIndex) {
    var newDate = _helper.getDateFromRowIndex(
      type: type,
      rowIndex: rowIndex,
      activeDate: _activeDate.value,
    );

    if (newDate.isAfter(_option.maxDate)) newDate = _activeDate.value;
    if (newDate.isBefore(_option.minDate)) newDate = _activeDate.value;

    /* Recheck positions */
    _recheckPosition(_DateTimeType.year, newDate);
    _recheckPosition(_DateTimeType.month, newDate);
    _recheckPosition(_DateTimeType.day, newDate);
    _recheckPosition(_DateTimeType.weekday, newDate);

    /* Set new date */
    _activeDate.value = newDate;
    widget.onChange?.call(newDate);

    return;
  }

  void _recheckPosition(_DateTimeType type, DateTime date) {
    final index = _option.dateTimeTypes.indexOf(type);
    if (index != -1) {
      late int targetPosition;

      switch (type) {
        case _DateTimeType.year:
          targetPosition = _helper.years.indexOf(date.year) + 1;
          break;
        case _DateTimeType.month:
          targetPosition = date.month;
          break;
        case _DateTimeType.day:
          targetPosition = date.day;
          break;
        case _DateTimeType.weekday:
          targetPosition = date.weekday;
          break;
        default:
          break;
      }
      _fixPosition(
        controller: _controllers[index],
        itemCount: _helper.itemCount(type),
        targetPosition: targetPosition,
      );
    }
  }

  void _fixPosition({
    required ScrollController controller,
    required int itemCount,
    required int targetPosition,
  }) {
    if (controller.hasClients) {
      final scrollPosition =
          (controller.offset / widget.itemExtent).floor() % itemCount + 1;

      if (targetPosition != scrollPosition) {
        final difference = scrollPosition - targetPosition;
        final endOffset = controller.offset - (difference * widget.itemExtent);

        if (!controller.position.isScrollingNotifier.value) {
          Future.delayed(Duration.zero, () {
            controller.animateTo(
              endOffset,
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceOut,
            );
          });
        }
      }
    }
  }
}
