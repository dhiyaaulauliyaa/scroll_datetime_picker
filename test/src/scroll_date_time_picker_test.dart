import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/src/scroll_date_time_picker.dart';

void main() {
  final testValues = [
    {'pattern': 'EEEE', 'initial': 'Tuesday', 'final': 'Sunday', 'steps': 5},
    {'pattern': 'yyyy', 'initial': '2023', 'final': '2026', 'steps': 5},
    {'pattern': 'MMM', 'initial': 'Feb', 'final': 'Jul', 'steps': 5},
    {'pattern': 'dd', 'initial': '07', 'final': '28', 'steps': 24},
    {'pattern': 'HH', 'initial': '10', 'final': '15', 'steps': 5},
    {'pattern': 'hh', 'initial': '10', 'final': '12', 'steps': 2},
    {'pattern': 'mm', 'initial': '10', 'final': '20', 'steps': 10},
    {'pattern': 'ss', 'initial': '10', 'final': '30', 'steps': 20},
    {'pattern': 'a', 'initial': 'AM', 'final': 'PM', 'steps': 5},
  ];

  group('test ScrollDateTimePicker', () {
    for (final val in testValues) {
      testWidgets(
        'when scrolled with ${val['pattern']} pattern, '
        'picker wheel should ends in correct value',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: _TestPage(
                format: DateFormat('${val['pattern']}'),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Make sure initial value is true
          expect(find.text('${val['initial']}'), findsAtLeastNWidgets(1));
          expect(
            find.text('${val['final']}'),
            val['pattern'] != 'a' ? findsNothing : findsAtLeastNWidgets(1),
          );

          // Drag down for five item
          await tester.drag(
            find.byKey(const Key('ScrollDateTimePicker')),
            Offset(0, 54.0 * -int.parse('${val['steps']}') + 10),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Make sure final value is true
          expect(find.text('${val['final']}'), findsAtLeastNWidgets(1));
          expect(
            find.text('${val['initial']}'),
            val['pattern'] != 'a' ? findsNothing : findsAtLeastNWidgets(1),
          );
        },
      );
    }
  });
}

class _TestPage extends StatefulWidget {
  const _TestPage({required this.format});

  final DateFormat format;

  @override
  State<_TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<_TestPage> {
  DateTime date = DateTime(2023, 2, 7, 10, 10, 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollDateTimePicker(
        key: const Key('ScrollDateTimePicker'),
        itemExtent: 54,
        onChange: (datetime) => setState(() {
          date = datetime;
        }),
        dateOption: DateTimePickerOption(
          dateFormat: widget.format,
          minDate: DateTime(2000, 6),
          maxDate: DateTime(2026, 6),
          initialDate: date,
        ),
        style: DateTimePickerStyle(
          centerDecoration: const BoxDecoration(color: Colors.white),
          activeStyle: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
          ),
          inactiveStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context).primaryColor.withOpacity(0.7),
          ),
          disabledStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}
