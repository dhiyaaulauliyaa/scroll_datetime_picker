import 'package:example/customizer/tabs/appearance_option_tab.dart';
import 'package:example/customizer/tabs/date_option_tab.dart';
import 'package:example/customizer/tabs/style_option_tab.dart';
import 'package:example/customizer/tabs/wheel_option_tab.dart';
import 'package:example/theme/app_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

class CustomizerScreen extends StatefulWidget {
  const CustomizerScreen({super.key});

  @override
  State<CustomizerScreen> createState() => _CustomizerScreenState();
}

class _CustomizerScreenState extends State<CustomizerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  DateTime date = DateTime.now();

  late double itemExtent;
  late int visibleItem;
  late bool infiniteScroll;
  late DateTimePickerStyle style;
  late DateTimePickerOption dateOption;
  late DateTimePickerWheelOption wheelOption;
  late DateTimePickerCenterWidget centerWidget;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 4,
      vsync: this,
    );

    itemExtent = 54;
    visibleItem = 4;
    infiniteScroll = true;
    style = DateTimePickerStyle(
      activeStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: AppColor.primary,
        letterSpacing: -1.5,
        fontFamily: 'BebasNeue',
        fontStyle: FontStyle.italic,
      ),
      inactiveStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColor.primary.withOpacity(0.5),
        letterSpacing: -1.5,
        fontFamily: 'BebasNeue',
        fontStyle: FontStyle.italic,
      ),
      disabledStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
        letterSpacing: -1.5,
        fontFamily: 'BebasNeue',
        fontStyle: FontStyle.italic,
      ),
    );
    centerWidget = DateTimePickerCenterWidget(
      builder: (context, constraints, child) => DecoratedBox(
        decoration: BoxDecoration(
          color: AppColor.secondary,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 3),
        ),
      ),
    );
    wheelOption = const DateTimePickerWheelOption(
      perspective: 0.01,
      diameterRatio: 1.5,
      squeeze: 1.1,
      offAxisFraction: 1.5,
      physics: BouncingScrollPhysics(),
    );
    dateOption = DateTimePickerOption(
      dateFormat: DateFormat('EddMMMy', 'en'),
      minDate: DateTime(2000, 6),
      maxDate: DateTime(2024, 6),
      initialDate: date,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customizer'),
      ),
      backgroundColor: Colors.grey[900]?.withOpacity(0.9),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: Column(
          children: [
            /* DateTimePicker */
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ScrollDateTimePicker(
                itemExtent: itemExtent,
                visibleItem: visibleItem,
                infiniteScroll: infiniteScroll,
                dateOption: dateOption,
                wheelOption: wheelOption,
                style: style,
                onChange: (datetime) => setState(() {
                  date = datetime;
                }),
              ),
            ),

            /* Tab Bar */
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.deepPurple[800],
                border: Border.all(width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: const Color(0xFFC8FC2E),
                  labelColor: Colors.white,
                  labelPadding: const EdgeInsets.all(16),
                  labelStyle: GoogleFonts.bebasNeue(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                  tabs: [
                    'Date Option.',
                    'Style Option.',
                    'Wheel Option.',
                    'Appearance Option.',
                  ].map(Text.new).toList(),
                ),
              ),
            ),

            /* Customizer Tabs */
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  DateOptionTab(
                    initialValue: dateOption,
                    onChanged: (value) => setState(
                      () => dateOption = value,
                    ),
                  ),
                  StyleOptionTab(
                    initialValue: style,
                    onChanged: (value) => setState(
                      () => style = value,
                    ),
                  ),
                  WheelOptionTab(
                    initialValue: wheelOption,
                    onChanged: (option) => setState(() {
                      wheelOption = option;
                    }),
                  ),
                  AppearanceOptionTab(
                    infiniteScroll: infiniteScroll,
                    visibleItem: visibleItem,
                    onInfiniteScrollChanged: (val) => setState(
                      () => infiniteScroll = val,
                    ),
                    onVisibleItemChanged: (val) => setState(
                      () => visibleItem = val.floor(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
