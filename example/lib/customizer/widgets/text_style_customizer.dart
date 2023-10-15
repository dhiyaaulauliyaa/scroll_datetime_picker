import 'package:example/customizer/widgets/customizer_base_tab.dart';
import 'package:example/customizer/widgets/customizer_color_tile.dart';
import 'package:example/customizer/widgets/customizer_list_tile.dart';
import 'package:example/customizer/widgets/customizer_slider_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';

class TextStyleCustomizer extends StatefulWidget {
  const TextStyleCustomizer({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final TextStyle initialValue;
  final void Function(TextStyle value) onChanged;

  @override
  State<TextStyleCustomizer> createState() => _TextStyleCustomizerState();
}

class _TextStyleCustomizerState extends State<TextStyleCustomizer> {
  late TextStyle _style;
  late TextEditingController _fontController;

  @override
  void initState() {
    super.initState();

    _style = widget.initialValue;
    _fontController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fontController.text = _style.fontFamily ??
          Theme.of(context).textTheme.bodyMedium?.fontFamily ??
          'null';
    });
  }

  @override
  void dispose() {
    _fontController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomizerBaseTab(
      child: Column(
        children: [
          CustomizerColorTile(
            activeColor: _style.color,
            onChanged: (color) => _onChanged(
              _style.copyWith(color: color),
            ),
          ),
          CustomizerSliderTile(
            label: 'Size',
            min: 0,
            max: 100,
            divisions: 100,
            text: _style.fontSize?.toInt().toString(),
            value: _style.fontSize ?? 12,
            onChanged: (value) => _onChanged(
              _style.copyWith(fontSize: value),
            ),
          ),
          CustomizerSliderTile(
            label: 'Weight',
            min: 0,
            max: 8,
            divisions: 8,
            value: _style.fontWeight?.index.toDouble() ?? 5.0,
            text: _style.fontWeight.toString(),
            onChanged: (value) => _onChanged(
              _style.copyWith(
                fontWeight: FontWeight.values[value.floor()],
              ),
            ),
          ),
          CustomizerSliderTile(
            label: 'Letter Spacing',
            min: -10,
            max: 20,
            divisions: 120,
            value: _style.letterSpacing ?? 0.0,
            text: _style.letterSpacing?.toStringAsPrecision(4) ?? '0',
            onChanged: (value) => _onChanged(
              _style.copyWith(
                letterSpacing: value,
              ),
            ),
          ),
          CustomizerListTile(
            label: 'Font',
            isLast: true,
            value: GestureDetector(
              onTap: () async {
                await showDialog<void>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: SizedBox(
                          width: double.maxFinite,
                          child: FontPicker(
                            showInDialog: true,
                            initialFontFamily: 'Anton',
                            onFontChanged: (font) {
                              _fontController.text = font.fontFamily;
                              _onChanged(
                                font.toTextStyle().copyWith(
                                      color: _style.color,
                                      fontSize: _style.fontSize,
                                      fontWeight: _style.fontWeight,
                                      letterSpacing: _style.letterSpacing,
                                    ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: TextFormField(
                controller: _fontController,
                textAlign: TextAlign.end,
                enabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChanged(TextStyle style) {
    setState(() {
      _style = style;
      widget.onChanged(style);
    });
  }
}

class FlutterFontPicker {}
