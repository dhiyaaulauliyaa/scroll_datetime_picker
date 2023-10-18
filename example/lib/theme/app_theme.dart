import 'package:example/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.primary,
      titleTextStyle: GoogleFonts.bebasNeue(
        fontSize: 28,
        fontStyle: FontStyle.italic,
        color: AppColor.white,
      ),
    ),
    textTheme: GoogleFonts.bebasNeueTextTheme().copyWith(),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateTextStyle.resolveWith(
          (states) => GoogleFonts.bebasNeue(
            color: states.contains(MaterialState.error)
                ? AppColor.error
                : AppColor.primary,
          ),
        ),
      ),
    ),
    colorSchemeSeed: AppColor.primary,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.primary,
      selectionHandleColor: AppColor.primary,
      selectionColor: AppColor.primary.withOpacity(0.2),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: InputBorder.none,
      border: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: EdgeInsets.zero,
    ),
  );
}
