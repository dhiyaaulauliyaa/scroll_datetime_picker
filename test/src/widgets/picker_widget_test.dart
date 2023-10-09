import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:scroll_datetime_picker/src/widgets/picker_widget.dart';

void main() {
  group('test PickerWidget', () {
    testWidgets(
      'when scrolled, should stop at correct position',
      (tester) async {
        // Arrange
        final scrollController = ScrollController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PickerWidget(
                itemCount: 20,
                itemExtent: 50,
                infiniteScroll: false,
                onChange: (_) {},
                controller: scrollController,
                centerWidget: const SizedBox(),
                activeBuilder: (_) => const SizedBox(),
                inactiveBuilder: (_) => const SizedBox(),
                wheelOption: const DateTimePickerWheelOption(),
              ),
            ),
          ),
        );
        final widgetFinder = find.byType(PickerWidget);
        final widget = tester.widget<PickerWidget>(widgetFinder);

        // Assert params
        expect(widget.itemCount, 20);
        expect(widget.itemExtent, 50);
        expect(widget.infiniteScroll, false);

        // Assert scroll offset when scrolled is a multiple of itemExtent
        await tester.drag(
          widgetFinder,
          Offset(0, widget.itemExtent * -2),
        );
        await tester.pumpAndSettle();
        expect(scrollController.offset, widget.itemExtent * 2);

        // Assert scroll offset when final value overshoots its itemExtent
        await tester.drag(
          widgetFinder,
          Offset(0, (widget.itemExtent * -2) - 10),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 200));
        expect(scrollController.offset, (widget.itemExtent * 2) * 2);

        // Assert scroll offset when final value undershoots its itemExtent
        await tester.drag(
          widgetFinder,
          Offset(0, (widget.itemExtent * -2) + 10),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 200));
        expect(scrollController.offset, (widget.itemExtent * 2) * 3);
      },
    );
  });
}
