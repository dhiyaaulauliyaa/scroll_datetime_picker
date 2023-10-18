import 'package:example/customizer/widgets/customizer_base_tab.dart';
import 'package:example/customizer/widgets/customizer_list_tile.dart';
import 'package:example/theme/app_color.dart';
import 'package:example/utils/extensions.dart';
import 'package:example/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

class DateOptionTab extends StatefulWidget {
  const DateOptionTab({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final DateTimePickerOption initialValue;
  final void Function(DateTimePickerOption value) onChanged;

  @override
  State<DateOptionTab> createState() => _DateOptionTabState();
}

class _DateOptionTabState extends State<DateOptionTab> {
  late final TextEditingController patternCtrl;
  late final TextEditingController localeCtrl;
  late final TextEditingController minDateCtrl;
  late final TextEditingController maxDateCtrl;

  late DateTimePickerOption _option;
  final formatter = DateFormat('yyyy-MM-dd hh:mm:ss a');

  @override
  void initState() {
    super.initState();

    _option = widget.initialValue;

    patternCtrl = TextEditingController(
      text: _option.dateFormat.pattern,
    );
    localeCtrl = TextEditingController(
      text: _option.dateFormat.locale,
    );
    minDateCtrl = TextEditingController(
      text: formatter.format(_option.minDate),
    );
    maxDateCtrl = TextEditingController(
      text: formatter.format(_option.maxDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomizerBaseTab(
          child: Column(
            children: [
              CustomizerListTile(
                label: 'Date Pattern',
                value: TextFormField(
                  controller: patternCtrl,
                  style: const TextStyle(fontSize: 20),
                  onFieldSubmitted: (value) {
                    final newOption = _option.copyWith(
                      dateFormat: DateFormat(
                        value,
                        _option.dateFormat.locale,
                      ),
                    );
                    final isValid = newOption.patterns.every(
                      (e) => e.checkPatternValidity,
                    );

                    if (!isValid) {
                      SnackbarUtil.showSnackbar(
                        context,
                        'Invalid date pattern: $value ',
                      );
                      return;
                    }

                    _onChanged(newOption);
                  },
                ),
              ),
              CustomizerListTile(
                label: 'Date Locale',
                value: TextFormField(
                  controller: localeCtrl,
                  style: const TextStyle(fontSize: 20),
                  onFieldSubmitted: (value) {
                    try {
                      DateFormat('E', value);
                      _onChanged(
                        _option.copyWith(
                          dateFormat: DateFormat(
                            _option.dateFormat.pattern,
                            value,
                          ),
                        ),
                      );
                    } catch (e) {
                      SnackbarUtil.showSnackbar(
                        context,
                        'Invalid locale: $value ',
                      );
                      return;
                    }
                  },
                ),
              ),
              CustomizerListTile(
                label: 'Minimum Date',
                value: GestureDetector(
                  onTap: () => showDialog<DateTime>(
                    context: context,
                    builder: (context) => DatePickerDialog(
                      initialDate: _option.minDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    ),
                  ).then((date) {
                    if (date == null) return;
                    if (date.isAfter(_option.maxDate)) {
                      SnackbarUtil.showSnackbar(
                        context,
                        'Minimum date should befor maximum date',
                      );
                    }

                    _onChanged(_option.copyWith(minDate: date));
                  }),
                  child: TextFormField(
                    controller: minDateCtrl,
                    enabled: false,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColor.black,
                    ),
                  ),
                ),
              ),
              CustomizerListTile(
                label: 'Maximum Date',
                isLast: true,
                value: GestureDetector(
                  onTap: () => showDialog<DateTime>(
                    context: context,
                    builder: (context) => DatePickerDialog(
                      initialDate: _option.maxDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    ),
                  ).then((date) {
                    if (date == null) return;
                    if (date.isBefore(_option.minDate)) {
                      SnackbarUtil.showSnackbar(
                        context,
                        'Minimum date should befor maximum date',
                      );
                    }

                    _onChanged(_option.copyWith(maxDate: date));
                  }),
                  child: TextFormField(
                    controller: maxDateCtrl,
                    enabled: false,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColor.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onChanged(DateTimePickerOption option) {
    setState(() {
      _option = option;
      widget.onChanged(_option);
    });
  }
}
