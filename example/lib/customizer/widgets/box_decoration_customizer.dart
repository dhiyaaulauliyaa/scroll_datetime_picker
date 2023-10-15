import 'package:example/customizer/widgets/customizer_base_tab.dart';
import 'package:example/customizer/widgets/customizer_color_tile.dart';
import 'package:example/customizer/widgets/customizer_slider_tile.dart';
import 'package:flutter/material.dart';

class BoxDecorationCustomizer extends StatefulWidget {
  const BoxDecorationCustomizer({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final BoxDecoration initialValue;
  final void Function(BoxDecoration value) onChanged;

  @override
  State<BoxDecorationCustomizer> createState() =>
      _BoxDecorationCustomizerState();
}

class _BoxDecorationCustomizerState extends State<BoxDecorationCustomizer> {
  late BoxDecoration _decoration;

  double _borderRadius = 0;

  @override
  void initState() {
    super.initState();

    _decoration = widget.initialValue;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomizerBaseTab(
      child: Column(
        children: [
          CustomizerColorTile(
            label: 'Background Color',
            activeColor: _decoration.color,
            onChanged: (color) => _onChanged(
              _decoration.copyWith(color: color),
            ),
          ),
          CustomizerColorTile(
            label: 'Border Color',
            activeColor: _decoration.border?.top.color,
            onChanged: (color) => _onChanged(
              _decoration.copyWith(
                border: Border.all(
                  color: color,
                  width: _decoration.border?.top.width ?? 1,
                ),
              ),
            ),
          ),
          CustomizerSliderTile(
            label: 'Border Thickness',
            min: 0,
            max: 20,
            text: (_decoration.border?.top.width ?? 1).toString(),
            value: _decoration.border?.top.width ?? 1,
            onChanged: (value) => _onChanged(
              _decoration.copyWith(
                border: Border.all(
                  color: _decoration.border?.top.color ?? Colors.black,
                  width: value,
                ),
              ),
            ),
          ),
          CustomizerSliderTile(
            label: 'Border Radius',
            min: 0,
            max: 100,
            isLast: true,
            text: _borderRadius.toString(),
            value: _borderRadius,
            onChanged: (value) {
              _borderRadius = value;

              _onChanged(
                _decoration.copyWith(
                  borderRadius: BorderRadius.circular(value),
                  border: Border.all(
                    color: _decoration.border?.top.color ?? Colors.black,
                    width: _decoration.border?.top.width ?? 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onChanged(BoxDecoration style) {
    setState(() {
      _decoration = style;
      widget.onChanged(style);
    });
  }
}

class FlutterFontPicker {}
