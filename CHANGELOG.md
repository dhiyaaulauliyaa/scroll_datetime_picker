## 0.2.0

- **New Feature:** Added `DateTimePickerController` to enable programmatic control over the picker's date and time selection.

## 0.1.2

- **Bug Fix:** Resolved issue where `setState` is called after widget is unmounted.

## 0.1.1

- **New Feature:** Added option `markOutOfRangeDateInvalid` to enable/disable marking out-of-range dates as invalid selections. When enabled, users cannot select dates outside the specified range.
- **Bug Fix:** Resolved issue where the `onChange` method did not include `setState`, causing the widget style in the Picker not to update.
- **Dependency Update:** Upgraded `intl` package to version 0.19.0 for improved compatibility and performance.

## 0.1.0

- **New Feature** Customizable Item Flex:
  Added `DatePickerItemFlex` to provide customization of each picker item's width by specifying the flex value for individual date/time items. This allows for precise control over the layout and distribution of space within the picker.
- **New Feature** Customizable Center Widget:
  Added `DateTimePickerCenterWidget`, offering greater flexibility in creating a custom widget for the center area of the picker.

## 0.0.4

- Added itemBuilder to provide customization for every item in the picker.

## 0.0.3

- Enhanced the logic for making outer widgets disappear when reaching the center area.
- Resolved a bug that caused empty patterns when using DateFormat with only one pattern type.
- Fixed an issue with the undefined scrollController when the pattern length is changed.
- Rectified an infinite loop problem during picker widget position rechecking.
- Added support for DateFormat patterns (LLL/LLLL).
- Introduced unit tests and widget tests, significantly improving code coverage for the repository.
- Developed a web application for package illustrative purposes.
- Enhanced the package example by incorporating device preview, customizer, and visual improvements.
- Improved the readme by including links to examples, comprehensive feature details, and a coverage badge.

## 0.0.2

- Add DateTimePickerWheelOption to enable scroll wheel customization
- Add doc comment to every public API
- Remove locale param from DateOption and replace it with locale from DateFormat (breaking)
- Upgrade intl package to 0.18.0

## 0.0.1

- First release, create ScrollDateTimePicker and its supporting objects & widgets.
