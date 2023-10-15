import 'package:example/theme/app_color.dart';
import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColor.error,
          content: Text(text),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              width: 2,
            ),
          ),
        ),
      );
  }
}
