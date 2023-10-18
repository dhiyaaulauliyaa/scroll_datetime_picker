import 'package:example/customizer/widgets/customizer_list_tile.dart';
import 'package:example/theme/app_color.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class CustomizerColorTile extends StatelessWidget {
  const CustomizerColorTile({
    super.key,
    required this.activeColor,
    required this.onChanged,
    this.label = 'Color',
    this.isLast = false,
  });

  final bool isLast;
  final String label;
  final Color? activeColor;
  final void Function(Color color) onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomizerListTile(
      label: label,
      isLast: isLast,
      value: GestureDetector(
        onTap: () async {
          await ColorPicker(
            hasBorder: true,
            showMaterialName: true,
            showColorName: true,
            showColorCode: true,
            onColorChanged: onChanged,
            color: activeColor ?? Colors.black,
            copyPasteBehavior: const ColorPickerCopyPasteBehavior(
              longPressMenu: true,
            ),
            enableOpacity: true,
            elevation: 2,
            borderColor: Colors.black,
            heading: Text(
              'Select color',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.both: false,
              ColorPickerType.primary: false,
              ColorPickerType.accent: false,
              ColorPickerType.bw: false,
              ColorPickerType.custom: true,
              ColorPickerType.wheel: true,
            },
          ).showPickerDialog(context);
        },
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: activeColor ?? Colors.white,
            border: Border.all(width: 2),
          ),
          child: Text(
            activeColor?.hex ?? 'NULL',
            style: TextStyle(
              color: (activeColor?.computeLuminance() ?? 1) > 0.5
                  ? AppColor.black
                  : AppColor.white,
            ),
          ),
        ),
      ),
    );
  }
}
