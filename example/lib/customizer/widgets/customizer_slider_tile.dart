import 'package:example/theme/app_color.dart';
import 'package:flutter/material.dart';

class CustomizerSliderTile extends StatelessWidget {
  const CustomizerSliderTile({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.text,
    this.divisions,
    this.isLast = false,
  });

  final bool isLast;
  final String label;
  final String? text;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${label.toUpperCase()}.',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    letterSpacing: -0.25,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text ?? value.toString(),
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
          if (!isLast)
            const Divider(
              color: AppColor.black,
              thickness: 1.5,
            ),
        ],
      ),
    );
  }
}
