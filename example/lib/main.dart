import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

void main() {
  initializeDateFormatting('en');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime date = DateTime.now();
  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ScrollDateTimePicker'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /* DATE */
          Text(
            'DATE PICKER',
            style: Theme.of(context).textTheme.headline5,
          ),
          ScrollDateTimePicker(
            itemExtent: 54,
            onChange: (datetime) => setState(() {
              date = datetime;
            }),
            dateOption: DateTimePickerOption(
              dateFormat: DateFormat('EddMMMy', 'fr'),
              minDate: DateTime(2000, 6),
              maxDate: DateTime(2024, 6),
              initialDate: date,
            ),
            wheelOption: const DateTimePickerWheelOption(
              offAxisFraction: 1.25,
              perspective: 0.01,
              squeeze: 1.2,
              clipBehavior: Clip.none,
              renderChildrenOutsideViewport: true,
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
          const SizedBox(height: 20),

          /* TIME */
          Text(
            'TIME PICKER',
            style: Theme.of(context).textTheme.headline5,
          ),
          ScrollDateTimePicker(
            itemExtent: 40,
            visibleItem: 4,
            infiniteScroll: true,
            dateOption: DateTimePickerOption(
              dateFormat: DateFormat('hhmmss a', 'en'),
              minDate: DateTime(2000, 6),
              maxDate: DateTime(2024, 6),
              initialDate: time,
            ),
            onChange: (datetime) => setState(() {
              time = datetime;
            }),
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
          const SizedBox(height: 20),
          Text(
            DateFormat('EEEE dd MMMM yyyy', 'en').format(date),
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            DateFormat('HH:mm:ss', 'en').format(time),
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
