import 'package:flutter/material.dart';

class PickerWidget extends StatelessWidget {
  const PickerWidget({
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

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
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
    );
  }

  bool _onNotification(ScrollNotification notification) {
    if (!controller.hasClients) return true;

    if (notification is ScrollEndNotification) {
      final overshoot = controller.offset % itemExtent;
      final lowestExtent = controller.offset - overshoot;
      final midExtent = itemExtent / 2;
      final endExtent =
          overshoot > midExtent ? lowestExtent + itemExtent : lowestExtent;

      Future.delayed(Duration.zero, () async {
        await controller.animateTo(
          endExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.bounceOut,
        );

        final rowIndex = (endExtent / itemExtent).floor() % itemCount;
        onChange.call(rowIndex);
      });
    }

    return true;
  }
}
