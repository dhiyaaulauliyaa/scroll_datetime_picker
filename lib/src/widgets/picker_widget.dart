part of '../scroll_date_time_picker.dart';

class _PickerWidget extends StatefulWidget {
  const _PickerWidget({
    required this.itemCount,
    required this.itemExtent,
    required this.infiniteScroll,
    required this.onChange,
    required this.controller,
    required this.centerWidget,
    required this.activeBuilder,
    required this.inactiveBuilder,
    required this.wheelOption,
  });

  final int itemCount;
  final double itemExtent;
  final bool infiniteScroll;

  final void Function(int index) onChange;
  final ScrollController controller;

  final Widget centerWidget;
  final Widget Function(int index) activeBuilder;
  final Widget Function(int index) inactiveBuilder;

  final DateTimePickerWheelOption wheelOption;

  @override
  State<_PickerWidget> createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<_PickerWidget> {
  late final DateTimePickerWheelOption _wheelOption;

  final _isProgrammaticScroll = ValueNotifier<bool>(false);
  final _centerScrollCtl = ScrollController();

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_scrollListener);
    _wheelOption = widget.wheelOption;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollListener);
    _isProgrammaticScroll.dispose();
    _centerScrollCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /* Main Scrollable */
        _ScrollTypeListener(
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
                builder: (context, index) {
                  return Container(
                    height: widget.itemExtent,
                    alignment: Alignment.center,
                    child: widget.inactiveBuilder.call(index),
                  );
                },
              ),
            ),
          ),
        ),

        /* Center Decoration */
        Align(child: IgnorePointer(child: widget.centerWidget)),

        /* Center */
        Align(
          child: IgnorePointer(
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
        ),
      ],
    );
  }

  void _scrollListener() {
    _centerScrollCtl.jumpTo(widget.controller.position.pixels);
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
