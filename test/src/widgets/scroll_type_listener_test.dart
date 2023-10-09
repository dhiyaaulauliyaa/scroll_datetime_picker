import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scroll_datetime_picker/src/widgets/scroll_type_listener.dart';

void main() {
  group('test ScrollTypeListener', () {
    testWidgets(
      'when triggered, should return correct value on callback',
      (tester) async {
        // Arrange
        final scrollController = ScrollController();
        var results = <bool>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollTypeListener(
                onScroll: (isProgrammaticScroll) {
                  results.add(isProgrammaticScroll);
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemBuilder: (context, index) => Text('$index'),
                ),
              ),
            ),
          ),
        );

        final widgetFinder = find.byType(ListView);

        // when manually scrolled,
        // isProgrammaticScroll callback should return false
        await tester.drag(widgetFinder, const Offset(0, -100));
        await tester.pumpAndSettle();
        expect(results.every((val) => val == false), true);

        // Reset values
        results = [];

        // when programmatically scrolled,
        // isProgrammaticScroll callback should return true
        scrollController.jumpTo(20);
        await tester.pumpAndSettle();
        expect(results.every((val) => val == true), true);
      },
    );
  });
}
