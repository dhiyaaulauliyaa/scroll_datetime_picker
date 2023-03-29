import 'package:flutter/material.dart';
import 'package:scroll_datetime_picker/src/widget/scroll_type_listener.dart';

class PickerWidget extends StatelessWidget {
  PickerWidget({
    super.key,
    required this.itemCount,
    required this.itemExtent,
    required this.infiniteScroll,
    required this.onChange,
    required this.controller,
    required this.builder,
  });

  final int itemCount;
  final double itemExtent;
  final bool infiniteScroll;

  final void Function(int index) onChange;

  final ScrollController controller;
  final Widget Function(int index) builder;

  final _isProgrammaticScroll = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ScrollTypeListener(
      onScroll: (isProgrammaticScroll) =>
          _isProgrammaticScroll.value = isProgrammaticScroll,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onNotification,
        child: ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: itemExtent,
          perspective: 0.001,
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: infiniteScroll ? null : itemCount,
            builder: (context, index) {
              return Container(
                height: itemExtent,
                alignment: Alignment.center,
                child: builder.call(index),
              );
            },
          ),
        ),
      ),
    );
  }

  bool _onNotification(ScrollNotification notification) {
    if (!controller.hasClients) return true;
    if (_isProgrammaticScroll.value) return true;

    /* Handle overshoot */
    if (notification is ScrollEndNotification) {
      final overshoot = controller.offset % itemExtent;
      final lowestExtent = controller.offset - overshoot;
      final midExtent = itemExtent / 2;
      final endExtent =
          overshoot > midExtent ? lowestExtent + itemExtent : lowestExtent;

      Future.delayed(Duration.zero, () async {
        /* Return if scrollView is still scrolling */
        if (controller.position.isScrollingNotifier.value) return true;

        if (controller.hasClients) {
          final allowChange = !_isProgrammaticScroll.value;
          final rowIndex = (endExtent / itemExtent).floor() % itemCount;

          await controller.animateTo(
            endExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.bounceOut,
          );

          if (allowChange) {
            onChange.call(rowIndex);
          }
        }
      });
    }

    return true;
  }
}
