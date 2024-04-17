import 'package:example/theme/app_color.dart';
import 'package:flutter/material.dart';

class CustomizerListTile extends StatelessWidget {
  const CustomizerListTile({
    super.key,
    required this.label,
    required this.value,
    this.labelFlex = 1,
    this.valueFlex = 1,
    this.isLast = false,
  });

  final bool isLast;

  final String label;
  final Widget value;

  final int labelFlex;
  final int valueFlex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: labelFlex,
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
              Expanded(
                flex: valueFlex,
                child: value,
              ),
            ],
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
