<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Scroll DateTime Picker

[![codecov](https://codecov.io/gh/dhiyaaulauliyaa/scroll_datetime_picker/graph/badge.svg?token=QAQX47A677)](https://codecov.io/gh/dhiyaaulauliyaa/scroll_datetime_picker)
[![pub package](https://img.shields.io/pub/v/scroll_datetime_picker.svg)](https://pub.dev/packages/scroll_datetime_picker)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/dhiyaaulauliyaa/scroll_datetime_picker/blob/master/LICENSE)

Welcome to the Scroll DateTime Picker – a versatile and highly customizable Flutter package that allows you to effortlessly pick dates, times, or both. Inspired by the CupertinoDatePicker, our package provides a wealth of features for your date and time selection needs.

## [🔬 Test The Package 🔬](https://dhiyaaulauliyaa.github.io/scroll_datetime_picker/#/)

- Access the example web page [here](https://dhiyaaulauliyaa.github.io/scroll_datetime_picker/#/)
- The homepage features a straightforward example of the Scroll DateTime Picker.
- To create your own configuration, access the `Customizer Page` by clicking the `Customize Here` button.

## Key Features

- [🗓️ Customize Date/Time Format](#%EF%B8%8F-customize-datetime-format)<br>
- [📅 Customize Date/Time Order](#-customize-datetime-order)<br>
- [🌍 Customize Date/Time Locale](#-customize-datetime-locale)<br>
- [✏️ Customize Date/Time TextStyles](#%EF%B8%8F-customize-datetime-textstyles)<br>
- [🛞 Customize Scroll Wheel Appearance](#-customize-scroll-wheel-appearance)<br>
- [🎨 Fully Customize Date/Time Picker Appearance](#-fully-customize-datetime-picker-appearance)<br>
- [📜 Choose Between Infinite/Finite Scroll](#-choose-between-infinitefinite-scroll)<br>
- [🧠 Smart Detection on Invalid Date & Leap Year Handling](#-smart-detection-on-invalid-date-and-leap-year-handling)<br>

## Usage

Add to pubspec.yaml

```
dart pub add scroll_datetime_picker
```

Import the package

```
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
```

Simple usage example

```
ScrollDateTimePicker(
  itemExtent: 54,
  infiniteScroll: true,
  dateOption: DateTimePickerOption(
    dateFormat: DateFormat('yyyyMMMdd'),
    minDate: DateTime(2000, 6),
    maxDate: DateTime(2024, 6),
    initialDate: time,
  ),
  onChange: (datetime) => setState(() {
    time = datetime;
  }),
),
```

## Features Details

### 🗓️ Customize Date/Time Format

> Tailor the date and time format to your specific requirements.

Easily modify the date and time format by adjusting the `dateFormat` property in `DateTimePickerOption`.

```
dateOption: DateTimePickerOption(
    dateFormat: DateFormat('EddMMMy'),
),
```

The pattern accepted is based on the [intl package](https://pub.dev/packages/intl). See the [DateFormat docs](https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html) to find more about the pattern. DateFormat example patterns:

- `EEEE, dd MMM yyyy` → Monday, 01 Jan 2000
- `hh:mm:ss a` → 06:30:00 pm
- `DateFormat.yMMMd()` → 2020 Jan 01
- `DateFormat.jms()` → 18:30:00

---

### 📅 Customize Date/Time Order

> Arrange date and time elements in your preferred order.

To customize Date/Time order to show on the picker, simply modify the pattern that is passed to the `dateFormat` param on `DateTimePickerOption`.
Example:

- To show Year-Month-Day:
  ```
  dateOption: DateTimePickerOption(
      dateFormat: DateFormat('yMMMMdd'),
  ),
  ```
- To show Day-Month-Year:
  ```
  dateOption: DateTimePickerOption(
      dateFormat: DateFormat('ddMMMMy'),
  ),
  ```

---

### 🌍 Customize Date/Time Locale

> Set the locale for date and time, ensuring localization accuracy.

Tailor the date and time locale displayed in the picker by passing the locale to the `dateFormat` parameter in `DateTimePickerOption`. If no locale is specified, the package will use the default locale. Locale options are based on the [intl package](https://pub.dev/packages/intl). See the [Locale docs](https://pub.dev/documentation/intl/latest/locale/Locale-class.html) to find more about the locale. Here's how to use it:

- English Locale:
  ```
  dateOption: DateTimePickerOption(
      dateFormat: DateFormat('yMMMMdd', 'en'),
  ),
  ```
- French Locale:
  ```
  dateOption: DateTimePickerOption(
      dateFormat: DateFormat('yMMMMdd', 'fr'),
  ),
  ```
- Default Locale:
  ```
  dateOption: DateTimePickerOption(
      dateFormat: DateFormat('ddMMMMy'),
  ),
  ```

---

### ✏️ Customize Date/Time TextStyles

> Craft your own text styles for a personalized appearance.

Personalize the appearance of the date and time text using the `DateTimePickerStyle` class. Adjust the `TextStyle` properties for:

- `ActiveStyle`: Style for text in the center area of the picker
- `InactiveStyle`: Style for text outside the center area.
- `DisabledStyle`: Style for invalid date/time text. Invalid date will be explained in [Invalid Date section](#-smart-detection-on-invalid-date-and-leap-year-handling)

Here's an example:

```
style: DateTimePickerStyle(
  activeStyle: TextStyle(
    fontSize: 24,
    letterSpacing: -0.5,
    color: Theme.of(context).primaryColor,
  ),
  inactiveStyle: TextStyle(
    fontSize: 20,
    color: Theme.of(context).primaryColor.withOpacity(0.7),
  ),
  disabledStyle: TextStyle(
    fontSize: 20,
    color: Theme.of(context).disabledColor,
  ),
),
```

---

### 🛞 Customize Scroll Wheel Appearance

> Define the wheel's appearance, from flat to rounded.

Set custom appearance for the picker wheel. The parameters here are based on flutter's [ListWheelScrollView](https://api.flutter.dev/flutter/widgets/ListWheelScrollView-class.html). You can make the picker looks flat or rounded like a wheel. Usage example:

```
wheelOption = const DateTimePickerWheelOption(
  perspective: 0.01,
  diameterRatio: 1.5,
  squeeze: 1.1,
  offAxisFraction: 1.5,
  physics: BouncingScrollPhysics(),
);
```

---

### 📜 Choose Between Infinite/Finite Scroll

> Opt for either finite or infinite scrolling, depending on your needs.

Choose between finite and infinite scrolling based on your requirements:

- Finite Scroll: The picker stops at the end of the scroll items.
  ```
  ScrollDateTimePicker(
    itemExtent: 54,
    infiniteScroll: false // Finite scroll
    onChange: (_){}
    dateOption: DateTimePickerOption(
      dateFormat: DateFormat('EddMMMy'),
      minDate: DateTime(2000, 6),
      maxDate: DateTime(2024, 6),
    ),
  ),
  ```
- Infinite Scroll: The picker is infinitely scrollable, with values repeating when reaching the end.
  ```
  ScrollDateTimePicker(
    itemExtent: 54,
    infiniteScroll: true // Infinite scroll
    onChange: (_){}
    dateOption: DateTimePickerOption(
      dateFormat: DateFormat('EddMMMy'),
      minDate: DateTime(2000, 6),
      maxDate: DateTime(2024, 6),
    ),
  ),
  ```

---

### 🎨 Fully Customize Date/Time Picker Appearance

> Gain complete control over the date/time picker's appearance with a variety of customization options:

#### Customize Flex Width for Every Date/Time Item

You can control the width (flex) of each date/time item using the `DateTimePickerItemFlex` class:

```dart
ScrollDateTimePicker(
  itemFlex: const DateTimePickerItemFlex(
    weekdayFlex: 7,
    dayFlex: 2,
    monthFlex: 8,
    yearFlex: 4,
  ),
),
```

In this example, the flex values for each item type (weekday, day, month, year) are specified.

#### Customize the Center Area of the Picker

You can customize the center area of the picker (usually the area that indicates the date/time chosen) using the `DateTimePickerCenterWidget` class. Users can choose to customize the center area for all items at once or individually for each date/time item:

```dart
ScrollDateTimePicker(
  centerWidget: DateTimePickerCenterWidget(
    builder: (context, constraints, child) => const DecoratedBox(
      decoration: ShapeDecoration(
        shape: StadiumBorder(side: BorderSide(width: 3)),
        color: AppColor.secondary,
      ),
    ),
  ),
),
```

In this example, the center area is customized with a specific shape decoration and color.

#### Customize Each Item Based on Its State

You can customize each item on the date picker based on its state (active at the center area, non-active outside the center area, disabled if the item is invalid) using the `itemBuilder` parameter:

```dart
ScrollDateTimePicker(
  itemBuilder: (context, pattern, text, isActive, isDisabled) =>
      Text(
        text,
        style: TextStyle(
          color: isDisabled
              ? Colors.grey
              : isActive
                  ? Colors.blue
                  : Colors.black,
        ),
  ),
),
```

In this example, the text style is customized based on whether the item is active or disabled.

#### Customize Using BoxDecoration

You can customize the visual aspects such as color, border, and border radius of the date/time picker using the `DateTimePickerStyle` class. Modify the `BoxDecoration` parameters to achieve your desired appearance:

- `ActiveDecoration`: Style for the widget in the center area of the picker.
- `InactiveDecoration`: Style for the widget outside the center area of the picker.
- `CenterDecoration`: Style that will be applied to the center area of the picker.

Here's an example:

```dart
style: DateTimePickerStyle(
  activeStyle: TextStyle(
    fontSize: 24,
    letterSpacing: -0.5,
    color: Theme.of(context).primaryColor,
  ),
  inactiveStyle: TextStyle(
    fontSize: 20,
    color: Theme.of(context).primaryColor.withOpacity(0.7),
  ),
  disabledStyle: TextStyle(
    fontSize: 20,
    color: Theme.of(context).disabledColor,
  ),
),
```

In this example, the active, inactive, and disabled item of the picker is customized with a specific TextStyle

---

### 🧠 Smart Detection on Invalid Date and Leap Year Handling

> Ensure a smooth experience with intelligent handling of invalid dates and leap years.

- If the picker wheel stops at a date before the minimum date or after the maximum date, it will automatically revert to the previous date.
- If the picker wheel stops at an invalid date (e.g. `31 Jun 2021`), the picker will automatically adjust the date. In this case, the day will automatically scrolled to be `30 Jun 2021`
- If the picker wheel stops at an invalid leap year date e.g. `30 Feb 2020`, the picker will automatically fix the invalid value. In this case, the day will automatically scrolled to be `29 Feb 2020`

## 😇 Contribute

We are always thrilled to welcome anyone who wishes to enhance this package. Your contributions are greatly appreciated! 🙇‍♂️

## 💡 Issue / Feature Requests

If you have specific features in mind, don't hesitate to let me know. Please open an issue to discuss your feature requests, and I'll be more than happy to consider them and collaborate towards making this package even better. 🙏
