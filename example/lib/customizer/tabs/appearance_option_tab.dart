import 'package:example/customizer/widgets/customizer_base_tab.dart';
import 'package:example/customizer/widgets/customizer_list_tile.dart';
import 'package:example/customizer/widgets/customizer_slider_tile.dart';
import 'package:flutter/material.dart';

class AppearanceOptionTab extends StatelessWidget {
  const AppearanceOptionTab({
    super.key,
    required this.infiniteScroll,
    required this.visibleItem,
    required this.onInfiniteScrollChanged,
    required this.onVisibleItemChanged,
  });

  final bool infiniteScroll;
  final int visibleItem;

  final void Function(bool) onInfiniteScrollChanged;
  final void Function(double) onVisibleItemChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomizerBaseTab(
          child: Column(
            children: [
              CustomizerListTile(
                label: 'Infinite Scroll',
                value: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Switch(
                      value: infiniteScroll,
                      onChanged: onInfiniteScrollChanged,
                    ),
                  ],
                ),
              ),
              CustomizerSliderTile(
                label: 'Visible Item',
                value: visibleItem * 1.0,
                min: 1,
                max: 5,
                divisions: 5,
                onChanged: onVisibleItemChanged,
              ),
              IgnorePointer(
                child: Opacity(
                  opacity: 0.5,
                  child: CustomizerSliderTile(
                    label: 'Item Extent',
                    value: 54,
                    min: 0,
                    max: MediaQuery.of(context).size.height * 0.08,
                    isLast: true,
                    onChanged: (value) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
