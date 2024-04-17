import 'package:example/customizer/widgets/box_decoration_customizer.dart';
import 'package:example/customizer/widgets/customizer_base_tab.dart';
import 'package:example/customizer/widgets/text_style_customizer.dart';
import 'package:example/theme/app_color.dart';
import 'package:example/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

class StyleOptionTab extends StatefulWidget {
  const StyleOptionTab({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final DateTimePickerStyle initialValue;
  final void Function(DateTimePickerStyle value) onChanged;

  @override
  State<StyleOptionTab> createState() => _StyleOptionTabState();
}

class _StyleOptionTabState extends State<StyleOptionTab> {
  bool _activeTextStyleOpen = false;
  bool _inactiveTextStyleOpen = false;
  bool _disabledTextStyleOpen = false;
  bool _activeDecorationOpen = false;
  bool _inactiveDecorationOpen = false;

  late DateTimePickerStyle _style;

  @override
  void initState() {
    super.initState();

    _style = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),

        // /* Center Decoration */
        // _SubHeader(
        //   title: 'Center Decoration',
        //   isOpened: _centerDecorationOpen,
        //   onTap: () => setState(() {
        //     _centerDecorationOpen = !_centerDecorationOpen;
        //   }),
        // ),
        // AnimatedSwitcher(
        //   duration: const Duration(milliseconds: 150),
        //   child: !_centerDecorationOpen
        //       ? const SizedBox(width: double.infinity)
        //       : BoxDecorationCustomizer(
        //           initialValue: _style.centerDecoration,
        //           onChanged: (value) => _onChanged(
        //             _style.copyWith(centerDecoration: value),
        //           ),
        //         ),
        // ),

        /* Active TextStyle */
        _SubHeader(
          title: 'Active TextStyle',
          isOpened: _activeTextStyleOpen,
          onTap: () => setState(() {
            _activeTextStyleOpen = !_activeTextStyleOpen;
          }),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: !_activeTextStyleOpen
              ? const SizedBox(width: double.infinity)
              : TextStyleCustomizer(
                  initialValue: _style.activeStyle ?? const TextStyle(),
                  onChanged: (value) => _onChanged(
                    _style.copyWith(activeStyle: value),
                  ),
                ),
        ),

        /* Inactive TextStyle */
        _SubHeader(
          title: 'Inactive TextStyle',
          isOpened: _inactiveTextStyleOpen,
          onTap: () => setState(() {
            _inactiveTextStyleOpen = !_inactiveTextStyleOpen;
          }),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: !_inactiveTextStyleOpen
              ? const SizedBox(width: double.infinity)
              : TextStyleCustomizer(
                  initialValue: _style.inactiveStyle ?? const TextStyle(),
                  onChanged: (value) => _onChanged(
                    _style.copyWith(inactiveStyle: value),
                  ),
                ),
        ),

        /* Disabled TextStyle */
        _SubHeader(
          title: 'Disabled TextStyle',
          isOpened: _disabledTextStyleOpen,
          onTap: () => setState(() {
            _disabledTextStyleOpen = !_disabledTextStyleOpen;
          }),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: !_disabledTextStyleOpen
              ? const SizedBox(width: double.infinity)
              : TextStyleCustomizer(
                  initialValue: _style.disabledStyle,
                  onChanged: (value) => _onChanged(
                    _style.copyWith(disabledStyle: value),
                  ),
                ),
        ),

        /* Active Decoration */
        _SubHeader(
          title: 'Active Decoration',
          isOpened: _activeDecorationOpen,
          onTap: () => setState(() {
            _activeDecorationOpen = !_activeDecorationOpen;
          }),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: !_activeDecorationOpen
              ? const SizedBox(width: double.infinity)
              : BoxDecorationCustomizer(
                  initialValue:
                      _style.activeDecoration ?? const BoxDecoration(),
                  onChanged: (value) => _onChanged(
                    _style.copyWith(activeDecoration: value),
                  ),
                ),
        ),

        /* Active Decoration */
        _SubHeader(
          title: 'Inactive Decoration',
          isOpened: _inactiveDecorationOpen,
          onTap: () => setState(() {
            _inactiveDecorationOpen = !_inactiveDecorationOpen;
          }),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: !_inactiveDecorationOpen
              ? const SizedBox(width: double.infinity)
              : BoxDecorationCustomizer(
                  initialValue:
                      _style.inactiveDecoration ?? const BoxDecoration(),
                  onChanged: (value) => _onChanged(
                    _style.copyWith(inactiveDecoration: value),
                  ),
                ),
        ),
      ],
    );
  }

  void _onChanged(DateTimePickerStyle style) {
    setState(() {
      _style = style;
      widget.onChanged(style);
    });
  }
}

class _SubHeader extends StatelessWidget {
  const _SubHeader({
    required this.title,
    required this.isOpened,
    required this.onTap,
  });

  final String title;
  final bool isOpened;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomizerBaseTab(
      backgroundColor: AppColor.error,
      margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(
        bottom: isOpened ? 0 : 16,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${title.toUpperCase()}.',
                style: const TextStyle(
                  fontSize: 22,
                  letterSpacing: -0.25,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: AppColor.white,
                ),
              ),
            ),
            Icon(
              isOpened ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
