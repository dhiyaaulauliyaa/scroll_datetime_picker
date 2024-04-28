import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/src/scroll_date_time_picker.dart';
import 'package:scroll_datetime_picker/src/widgets/picker_widget.dart';

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

    testWidgets(
      'when itemBuilder is not null, '
      'ScrollDateTimePicker should show item based on itemBuilder',
      (tester) async {
        const itemBuilderColor = Color(0xFF4527A0);
        const styleColor = Color(0xFFC8FC2E);

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollDateTimePicker(
              key: const Key('ScrollDateTimePicker'),
              itemExtent: 54,
              onChange: (datetime) {},
              dateOption: DateTimePickerOption(
                dateFormat: DateFormat.yMMMMd(),
                minDate: DateTime(2000, 6),
                maxDate: DateTime(2026, 6),
                initialDate: DateTime(2020),
              ),
              style: DateTimePickerStyle(
                activeStyle: const TextStyle(color: styleColor),
              ),
              itemBuilder: (
                context,
                pattern,
                text,
                isActive,
                isDisabled,
              ) =>
                  Text(
                text,
                key: text == '2020' ? const ValueKey('2020') : null,
                style: isDisabled
                    ? const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      )
                    : isActive
                        ? const TextStyle(
                            fontSize: 20,
                            color: itemBuilderColor,
                            fontWeight: FontWeight.w700,
                          )
                        : TextStyle(
                            fontSize: 18,
                            color: itemBuilderColor.withOpacity(0.7),
                          ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        final text = tester.widget<Text>(
          find.byKey(const ValueKey('2020')).last,
        );

        expect(text.style?.color == itemBuilderColor, true);
        expect(text.style?.color != styleColor, true);
      },
    );

    testWidgets(
      'when dateFormat is changed, '
      'ScrollDateTimePicker should adjust its controllers',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestPage(
              format: DateFormat('EEEEyyMMMdd'),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        // Make sure initial value is true
        expect(find.byType(PickerWidget), findsNWidgets(4));

        // Increase DateFormat
        await tester.tap(find.byKey(const ValueKey('Increase Pattern')));
        await tester.pumpAndSettle();

        // Make sure number of picker is true after DateFormat is increased
        expect(find.byType(PickerWidget), findsNWidgets(8));

        // Decrease DateFormat
        await tester.tap(find.byKey(const ValueKey('Decrease Pattern')));
        await tester.pumpAndSettle();

        // Make sure number of picker is true after DateFormat is decreased
        expect(find.byType(PickerWidget), findsNWidgets(7));
      },
    );
  });

  testWidgets('ScrollDateTimePicker applies itemFlex correctly',
      (tester) async {
    const customItemFlex = DateTimePickerItemFlex(
      yearFlex: 3,
      monthFlex: 4,
      dayFlex: 2,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ScrollDateTimePicker(
          key: const Key('ScrollDateTimePicker'),
          itemExtent: 54,
          dateOption: DateTimePickerOption(
            dateFormat: DateFormat('yyyyMMdd'),
            minDate: DateTime(2020),
            maxDate: DateTime(2025),
            initialDate: DateTime(2023),
          ),
          onChange: (datetime) {},
          itemFlex: customItemFlex,
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    // Find the expanded widget with correct flex value based on the itemFlex
    final yearWidgetFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Expanded && widget.flex == customItemFlex.yearFlex,
    );
    final monthWidgetFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Expanded && widget.flex == customItemFlex.monthFlex,
    );
    final dayWidgetFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Expanded && widget.flex == customItemFlex.dayFlex,
    );

    // Expect the expanded widget with correct flex value based on the itemFlex is exists
    expect(yearWidgetFinder, findsOneWidget);
    expect(monthWidgetFinder, findsOneWidget);
    expect(dayWidgetFinder, findsOneWidget);

    // Verify the flex values of each picker widget
    expect(
      tester.widget<Expanded>(yearWidgetFinder).flex,
      equals(customItemFlex.yearFlex),
    );
    expect(
      tester.widget<Expanded>(monthWidgetFinder).flex,
      equals(customItemFlex.monthFlex),
    );
    expect(
      tester.widget<Expanded>(dayWidgetFinder).flex,
      equals(customItemFlex.dayFlex),
    );

    // Expect the expanded widget with unmatch flex value based on item flex is not found
    final widgetFinder = find.byWidgetPredicate(
      (Widget widget) => widget is Expanded && widget.flex == 10000,
    );
    expect(widgetFinder, findsNothing);
  });

  testWidgets('ScrollDateTimePicker uses centerWidget correctly',
      (tester) async {
    final customCenterWidget = DateTimePickerCenterWidget(
      year: const DecoratedBox(
        key: ValueKey('Y-CenterWidget'),
        decoration: BoxDecoration(color: Colors.amber),
      ),
      month: const DecoratedBox(
        key: ValueKey('M-CenterWidget'),
        decoration: BoxDecoration(color: Colors.amber),
      ),
      day: const DecoratedBox(
        key: ValueKey('D-CenterWidget'),
        decoration: BoxDecoration(color: Colors.amber),
      ),
      hour24: const DecoratedBox(
        key: ValueKey('H24-CenterWidget'),
        decoration: BoxDecoration(color: Colors.amber),
      ),
      minute: const DecoratedBox(
        key: ValueKey('Min-CenterWidget'),
        decoration: BoxDecoration(color: Colors.amber),
      ),
      second: const DecoratedBox(
        key: ValueKey('Sec-CenterWidget'),
        decoration: BoxDecoration(color: Colors.amber),
      ),
      builder: (context, constraints, child) => child,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ScrollDateTimePicker(
          key: const Key('ScrollDateTimePicker'),
          itemExtent: 54,
          dateOption: DateTimePickerOption(
            dateFormat: DateFormat('yyyyMMddHHmmss'),
            minDate: DateTime(2020),
            maxDate: DateTime(2025),
            initialDate: DateTime(2023),
          ),
          onChange: (datetime) {},
          centerWidget: customCenterWidget,
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    // Find the center widget based on value key
    final yearFinder = find.byKey(customCenterWidget.year!.key!);
    final monthFinder = find.byKey(customCenterWidget.month!.key!);
    final dayFinder = find.byKey(customCenterWidget.day!.key!);
    final hour24Finder = find.byKey(customCenterWidget.hour24!.key!);
    final minuteFinder = find.byKey(customCenterWidget.minute!.key!);
    final secondFinder = find.byKey(customCenterWidget.second!.key!);

    // Verify every center widget was found
    expect(yearFinder, findsOneWidget);
    expect(monthFinder, findsOneWidget);
    expect(dayFinder, findsOneWidget);
    expect(hour24Finder, findsOneWidget);
    expect(minuteFinder, findsOneWidget);
    expect(secondFinder, findsOneWidget);
  });

  group(
    'ScrollDateTimePicker mark invalid date properly based on the markOutOfRangeDateInvalid',
    () {
      testWidgets(
        'should return to initial date when date chosen is out of range and markOutOfRangeDateInvalid is true ',
        (tester) async {
          final initialDate = DateTime(2023, 2);
          final minDate = DateTime(2023);
          final maxDate = DateTime(2023, 3);
          const scrollSteps = 5;

          late DateTime selectedDate;

          await tester.pumpWidget(
            MaterialApp(
              home: _TestPage(
                format: DateFormat('MMMyyyy'),
                // ignore: avoid_redundant_argument_values
                markOutOfRangeDateInvalid: true,
                dateOption: DateTimePickerOption(
                  dateFormat: DateFormat('MMyyyy'),
                  minDate: minDate,
                  maxDate: maxDate,
                  initialDate: initialDate,
                ),
                onChange: (datetime) => selectedDate = datetime,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Drag down for five item
          await tester.drag(
            find.byType(ListWheelScrollView).first,
            const Offset(0, -54.0 * scrollSteps + 10),
            warnIfMissed: false,
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Make sure the datetime selected is not exceed the date range
          // when markOutOfRangeDateInvalid is true
          expect(selectedDate.year, initialDate.year);
          expect(selectedDate.month, initialDate.month);
        },
      );

      testWidgets(
        'should keep the selected date even when date chosen is out of range and markOutOfRangeDateInvalid is false ',
        (tester) async {
          final initialDate = DateTime(2023, 2);
          final minDate = DateTime(2023);
          final maxDate = DateTime(2023, 3);
          const scrollSteps = 5;

          late DateTime selectedDate;

          await tester.pumpWidget(
            MaterialApp(
              home: _TestPage(
                format: DateFormat('MMMyyyy'),
                // ignore: avoid_redundant_argument_values
                markOutOfRangeDateInvalid: false,
                dateOption: DateTimePickerOption(
                  dateFormat: DateFormat('MMyyyy'),
                  minDate: minDate,
                  maxDate: maxDate,
                  initialDate: initialDate,
                ),
                onChange: (datetime) => selectedDate = datetime,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Drag down for five item
          await tester.drag(
            find.byType(ListWheelScrollView).first,
            const Offset(0, -54.0 * scrollSteps + 10),
            warnIfMissed: false,
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Make sure the datetime selected is not exceed the date range
          // when markOutOfRangeDateInvalid is true
          expect(selectedDate.year, initialDate.year);
          expect(selectedDate.month, initialDate.month + scrollSteps);
        },
      );
    },
  );
}

class _TestPage extends StatefulWidget {
  const _TestPage({
    required this.format,
    this.dateOption,
    this.onChange,
    this.markOutOfRangeDateInvalid = true,
  });

  final DateFormat format;
  final DateTimePickerOption? dateOption;
  final bool markOutOfRangeDateInvalid;
  final void Function(DateTime datetime)? onChange;

  @override
  State<_TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<_TestPage> {
  DateTime date = DateTime(2023, 2, 7, 10, 10, 10);
  late DateFormat _format;

  @override
  void initState() {
    super.initState();

    _format = widget.format;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Column(
        children: [
          FloatingActionButton(
            key: const ValueKey('Increase Pattern'),
            onPressed: () {
              setState(
                () => _format = DateFormat('EEEEyMMMddhhmmssa'),
              );
            },
          ),
          FloatingActionButton(
            key: const ValueKey('Decrease Pattern'),
            onPressed: () {
              setState(
                () => _format = DateFormat('EEEEyMMMddHHmmss'),
              );
            },
          ),
        ],
      ),
      body: ScrollDateTimePicker(
        key: const Key('ScrollDateTimePicker'),
        itemExtent: 54,
        markOutOfRangeDateInvalid: widget.markOutOfRangeDateInvalid,
        onChange: (datetime) => setState(() {
          widget.onChange?.call(datetime);
          date = datetime;
        }),
        dateOption: widget.dateOption ??
            DateTimePickerOption(
              dateFormat: _format,
              minDate: DateTime(2000, 6),
              maxDate: DateTime(2026, 6),
              initialDate: date,
            ),
        style: DateTimePickerStyle(
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
