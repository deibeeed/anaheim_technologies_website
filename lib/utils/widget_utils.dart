import 'package:anaheim_technologies_website/utils/gradient_utils.dart';
import 'package:flutter/material.dart';

class WidgetUtils {
  /// default background of the screens.
  ///
  /// all screens should implement this background
  /// if screens are not extended.
  static Widget defaultBackground({
    required BuildContext context,
    Widget? child,
  }) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Colors.black,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: GradientUtils.singleGradient,
          ),
          child: child,
        ),
      ),
    );
  }

  /// background of the screen that is using
  /// a 2 pass gradient
  static Widget extendedBackground({
    required BuildContext context,
    required double height,
    double? width,
    Widget? child,
  }) {
    final screenSize = MediaQuery.of(context).size;
    var finalWidth = screenSize.width;

    if (width != null) {
      finalWidth = width;
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: finalWidth,
        height: height,
        child: ColoredBox(
          color: Colors.black,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: GradientUtils.extendedGradient,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
