import 'package:example/customizer/widgets/customizer_base_tab.dart';
import 'package:example/customizer/widgets/customizer_list_tile.dart';
import 'package:example/customizer/widgets/customizer_slider_tile.dart';
import 'package:example/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

class WheelOptionTab extends StatefulWidget {
  const WheelOptionTab({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final DateTimePickerWheelOption initialValue;
  final void Function(DateTimePickerWheelOption option) onChanged;

  @override
  State<WheelOptionTab> createState() => _WheelOptionTabState();
}

class _WheelOptionTabState extends State<WheelOptionTab> {
  late DateTimePickerWheelOption _option;

  static const physics = [
    BouncingScrollPhysics(),
    ClampingScrollPhysics(),
    NeverScrollableScrollPhysics(),
  ];
  static const clip = [
    Clip.none,
    Clip.hardEdge,
    Clip.antiAlias,
  ];

  @override
  void initState() {
    super.initState();

    _option = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomizerBaseTab(
          child: Column(
            children: [
              CustomizerSliderTile(
                label: 'Perspective',
                value: _option.perspective,
                min: 0.0000000001,
                max: 0.01,
                onChanged: (value) => _onChanged(
                  _option.copyWith(perspective: value),
                ),
              ),
              CustomizerSliderTile(
                label: 'Diameter Ratio',
                value: _option.diameterRatio,
                min: 0.1,
                max: 3.5,
                onChanged: (value) => _onChanged(
                  _option.copyWith(diameterRatio: value),
                ),
              ),
              CustomizerSliderTile(
                label: 'Squeeze',
                value: _option.squeeze,
                min: 0.0000000001,
                max: 15,
                onChanged: (value) => _onChanged(
                  _option.copyWith(squeeze: value),
                ),
              ),
              CustomizerSliderTile(
                label: 'Off Axis Fraction',
                value: _option.offAxisFraction,
                min: -10,
                max: 10,
                onChanged: (value) => _onChanged(
                  _option.copyWith(offAxisFraction: value),
                ),
              ),
              CustomizerListTile(
                label: 'Physics',
                valueFlex: 2,
                value: DropdownButtonFormField<ScrollPhysics>(
                  value: _option.physics,
                  isExpanded: true,
                  onChanged: (value) => _onChanged(
                    _option.copyWith(physics: value),
                  ),
                  items: physics
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              CustomizerListTile(
                label: 'Clip Behavior',
                value: DropdownButtonFormField<Clip>(
                  value: _option.clipBehavior,
                  isExpanded: true,
                  onChanged: (value) => _onChanged(
                    _option.copyWith(
                      clipBehavior: value,
                      renderChildrenOutsideViewport:
                          value == Clip.none ? true : false,
                    ),
                  ),
                  items: clip
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              CustomizerListTile(
                label: 'Render Children Outside Viewport',
                isLast: true,
                value: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Switch(
                      value: _option.renderChildrenOutsideViewport,
                      onChanged: (value) => _onChanged(
                        _option.copyWith(
                          renderChildrenOutsideViewport: value,
                          clipBehavior: value ? Clip.none : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onChanged(DateTimePickerWheelOption option) {
    setState(() {
      _option = option;
      widget.onChanged(_option);
    });
  }
}
