import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ScrollTypeListener extends StatelessWidget {
  ScrollTypeListener({
    super.key,
    required this.child,
    required this.onScroll,
  });

  final Widget child;
  final void Function(bool isProgrammaticScroll) onScroll;

  final scrollSequence = ValueNotifier<List<Type>>([]);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (scrollSequence.value.length < 2) {
          if (scrollSequence.value.length == 1) {
            scrollSequence.value.add(notification.runtimeType);
          }

          if (notification is ScrollStartNotification) {
            scrollSequence.value = [ScrollStartNotification];
          }
        }

        if (notification is ScrollUpdateNotification) {
          onScroll.call(
            scrollSequence.value.lastOrNull != UserScrollNotification,
          );
        }

        if (notification is ScrollEndNotification) {
          scrollSequence.value = [];
        }

        return false;
      },
      child: child,
    );
  }
}
