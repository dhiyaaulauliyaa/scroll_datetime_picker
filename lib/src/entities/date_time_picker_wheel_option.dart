import 'package:flutter/material.dart';

/// Set custom appearance for the picker wheel
/// 
/// The parameters here are based on flutter's [ListWheelScrollView]
class DateTimePickerWheelOption {
  const DateTimePickerWheelOption({
    this.perspective = 0.005,
    this.diameterRatio = 1.75,
    this.offAxisFraction = 0,
    this.squeeze = 1,
    this.physics,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
  });

  /// How the scroll view should respond to user input when it is overscrolled.
  ///
  /// If null, the physics will use the platform default
  final ScrollPhysics? physics;

  /// How the picker clip the children
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// Whether to paint children inside the viewport only or not.
  ///
  /// If false, every child will be painted. However the size of the picker
  /// is still the size of the viewport and only detects gestures that is
  /// inputted inside the picker area.
  ///
  /// Defaults to false. Must not be null.
  ///
  /// Cannot be true if [clipBehavior] is not [Clip.none]
  /// since children outside the viewport will be clipped,
  /// and therefore cannot render children outside the viewport.
  final bool renderChildrenOutsideViewport;

  /// This value will strengthen the wheel effect. 
  /// - The bigger the value, the appereance will be rounder.
  /// - The lower the value, the appereance will be flatter.
  /// 
  /// Value allowed is > 0 && < 0.01
  /// 
  /// Defaults to 0.005 
  final double perspective;

  /// A ratio between the diameter of the cylinder and
  /// the viewport's size in the main axis.
  /// - Value == 1 will make the cylinder has the same diameter as the viewport's size.
  /// - Value < 1 will make items at the edges of the cylinder are entirely contained inside the viewport.
  /// - Value > 1 means angles less than ±[pi] / 2 from the center of the cylinder are visible.
  /// 
  /// Defaults to 1.75
  final double diameterRatio;

  /// Defines how much the picker's scroll wheel is placed horizontally
  /// off-center, as a fraction of its width.
  ///
  /// Will create the visual effect of looking at a
  /// vertical wheel from the side.
  ///
  /// The value is horizontal distance between the wheel's center and
  /// the vertical vanishing line at the edges of the wheel,
  /// represented as a fraction of the wheel's width.
  /// - Positive value means the wheel will bent towards its left side
  /// - Negative value means the wheel will bent towards its right side
  ///
  /// Defaults to 0.0.
  final double offAxisFraction;

  /// Defines distance beetween the picker's child.
  /// The higher the squeeze, the smaller the distance.
  ///
  /// Defaults to 1.
  final double squeeze;
}
