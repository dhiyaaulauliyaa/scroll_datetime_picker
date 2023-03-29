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
      appBar: AppBar(
        title: const Text('ScrollDatetimePicker'),
      ),
      body: Column(
        children: [
          ScrollDatePicker(
            itemExtent: 54,
            // infiniteScroll: true,
            dateOption: DatePickerOption(
              minDate: DateTime(2000),
              initialDate: date,
              locale: const Locale('id', 'ID'),
            ),
            onChange: (datetime) => setState(() {
              date = datetime;
            }),
          ),
          const SizedBox(height: 20),
          Text(DateFormat('dd MMMM yyyy', 'id').format(date)),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Show'),
            onPressed: () async {
              await showModalBottomSheet<DateTime>(
                context: context,
                builder: (context) {
                  return ScrollDatePicker(
                    itemExtent: 54,
                    infiniteScroll: false,
                    dateOption: DatePickerOption(
                      minDate: DateTime(2000),
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
