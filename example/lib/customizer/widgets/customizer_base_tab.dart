import 'package:example/theme/app_color.dart';
import 'package:flutter/cupertino.dart';

class CustomizerBaseTab extends StatelessWidget {
  const CustomizerBaseTab({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.all(16),
    this.backgroundColor = AppColor.secondary,
  });

  final Widget child;
  final Color backgroundColor;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
