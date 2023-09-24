import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

void main() {
  initializeDateFormatting('id');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ScrollDateTimePicker'),
      ),
      body: Column(
        children: [
          ScrollDateTimePicker(
            itemExtent: 54,
            infiniteScroll: false,
            dateOption: DateTimePickerOption(
              dateFormat: DateFormat('EddMMMy'),
              minDate: DateTime(2000, 6),
              maxDate: DateTime(2024, 6),
              initialDate: date,
              locale: const Locale('id', 'ID'),
            ),
            onChange: (datetime) => setState(() {
              date = datetime;
            }),
            style: DateTimePickerStyle(
              centerDecoration: const BoxDecoration(color: Colors.white),
              activeStyle: TextStyle(
                fontSize: 20,
                color: Colors.blue[900],
                fontWeight: FontWeight.w700,
              ),
              inactiveStyle: TextStyle(fontSize: 18, color: Colors.blue[600]),
              disabledStyle: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          Text(DateFormat('EEEE dd MMMM yyyy hh:mm a', 'id').format(date)),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Show'),
            onPressed: () async {
              await showModalBottomSheet<DateTime>(
                context: context,
                builder: (context) {
                  return ScrollDateTimePicker(
                    itemExtent: 54,
                    infiniteScroll: false,
                    dateOption: DateTimePickerOption(
                      dateFormat: DateFormat.yMMMMd(),
                      minDate: DateTime(2000),
                      maxDate: DateTime.now().add(Duration(days: 365)),
                      initialDate: date,
                      locale: const Locale('id', 'ID'),
                    ),
                    onChange: (datetime) => setState(() {
                      date = datetime;
                    }),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
