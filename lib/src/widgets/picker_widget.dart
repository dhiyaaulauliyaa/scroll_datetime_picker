import 'package:flutter/material.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:scroll_datetime_picker/src/widgets/scroll_type_listener.dart';

class PickerWidget extends StatefulWidget {
  const PickerWidget({
    super.key,
    required this.itemCount,
    required this.itemExtent,
    required this.infiniteScroll,
    required this.onChange,
    required this.controller,
    required this.activeBuilder,
    required this.inactiveBuilder,
    required this.wheelOption,
  });

  final int itemCount;
  final double itemExtent;
  final bool infiniteScroll;

  final void Function(int index) onChange;
  final ScrollController controller;
  final Widget Function(int index) activeBuilder;
  final Widget Function(int index) inactiveBuilder;

  final DateTimePickerWheelOption wheelOption;

  @override
  State<PickerWidget> createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget> {
  late DateTimePickerWheelOption _wheelOption;

  final _isProgrammaticScroll = ValueNotifier<bool>(false);
  final _centerScrollCtl = ScrollController();
  final _outerScrollCtl = ScrollController();

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_scrollListener);
    _wheelOption = widget.wheelOption;
  }

  @override
  void didUpdateWidget(covariant PickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.wheelOption != _wheelOption) {
      setState(() {
        _wheelOption = widget.wheelOption;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollListener);
    _isProgrammaticScroll.dispose();
    _centerScrollCtl.dispose();
    _outerScrollCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /* Main Scrollable */
        IgnorePointer(
          child: ClipPath(
            clipper: _OuterWidgetClipper(
              itemExtent: widget.itemExtent,
            ),
            child: ListWheelScrollView.useDelegate(
              controller: _outerScrollCtl,
              itemExtent: widget.itemExtent,
              physics: _wheelOption.physics,
              perspective: _wheelOption.perspective,
              diameterRatio: _wheelOption.diameterRatio,
              offAxisFraction: _wheelOption.offAxisFraction,
              squeeze: _wheelOption.squeeze,
              renderChildrenOutsideViewport:
                  _wheelOption.renderChildrenOutsideViewport,
              clipBehavior: _wheelOption.clipBehavior,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.infiniteScroll ? null : widget.itemCount,
                builder: (context, index) => Container(
                  height: widget.itemExtent,
                  alignment: Alignment.center,
                  child: widget.inactiveBuilder.call(index),
                ),
              ),
            ),
          ),
        ),

        /* Center */
        IgnorePointer(
          child: SizedBox(
            height: widget.itemExtent,
            child: ListWheelScrollView.useDelegate(
              controller: _centerScrollCtl,
              itemExtent: widget.itemExtent,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.infiniteScroll ? null : widget.itemCount,
                builder: (context, index) => Container(
                  height: widget.itemExtent,
                  alignment: Alignment.center,
                  child: widget.activeBuilder.call(index),
                ),
              ),
            ),
          ),
        ),

        /* Main Scrollable */
        ScrollTypeListener(
          onScroll: (isProgrammaticScroll) =>
              _isProgrammaticScroll.value = isProgrammaticScroll,
          child: NotificationListener<ScrollNotification>(
            onNotification: _onNotification,
            child: ListWheelScrollView.useDelegate(
              controller: widget.controller,
              itemExtent: widget.itemExtent,
              physics: _wheelOption.physics,
              perspective: _wheelOption.perspective,
              diameterRatio: _wheelOption.diameterRatio,
              offAxisFraction: _wheelOption.offAxisFraction,
              squeeze: _wheelOption.squeeze,
              renderChildrenOutsideViewport:
                  _wheelOption.renderChildrenOutsideViewport,
              clipBehavior: _wheelOption.clipBehavior,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.infiniteScroll ? null : widget.itemCount,
                builder: (_, __) => SizedBox(height: widget.itemExtent),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _scrollListener() {
    _centerScrollCtl.jumpTo(widget.controller.position.pixels);
    _outerScrollCtl.jumpTo(widget.controller.position.pixels);
  }

  bool _onNotification(ScrollNotification notification) {
    if (!widget.controller.hasClients) return true;
    if (_isProgrammaticScroll.value) return true;

    /* Handle overshoot */
    if (notification is ScrollEndNotification) {
      final overshoot = widget.controller.offset % widget.itemExtent;
      final lowestExtent = widget.controller.offset - overshoot;
      final midExtent = widget.itemExtent / 2;
      final endExtent = overshoot > midExtent
          ? lowestExtent + widget.itemExtent
          : lowestExtent;

      Future.delayed(Duration.zero, () async {
        /* Return if scrollView is still scrolling */
        if (widget.controller.position.isScrollingNotifier.value) return true;

        /* Return if controller doesn't have client */
        if (!widget.controller.hasClients) return true;

        final allowChange = !_isProgrammaticScroll.value;
        final rowIndex =
            (endExtent / widget.itemExtent).floor() % widget.itemCount;

        await widget.controller.animateTo(
          endExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.bounceOut,
        );

        if (allowChange) {
          widget.onChange.call(rowIndex);
        }
      });
    }

    return true;
  }
}

class _OuterWidgetClipper extends CustomClipper<Path> {
  const _OuterWidgetClipper({
    required this.itemExtent,
  });

  final double itemExtent;

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

  @override
  Path getClip(Size size) {
    const xMin = 0.0;
    final xMax = size.width;
    final yMin = (size.height - itemExtent) / 2;
    final yMax = yMin + itemExtent;

    final upperRect = Rect.fromPoints(
      Offset.zero,
      Offset(xMax, yMin),
    );
    final lowerRect = Rect.fromPoints(
      Offset(xMin, yMax),
      Offset(size.width, size.height),
    );

    final path = Path()
      ..addRect(upperRect)
      ..addRect(lowerRect)
      ..close();

    return path;
  }
}
