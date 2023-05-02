import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/gradient_utils.dart';
import 'package:anaheim_technologies_website/utils/print_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class HoveredText extends StatefulWidget {
  const HoveredText({
    super.key,
    required this.text,
    required this.navigateTo,
    this.textStyle = const TextStyle(fontFamily: 'Plavsky'),
    this.underlineColor = AppColors.foregroundColor,
  });

  final String text;
  final Color underlineColor;
  final TextStyle textStyle;
  final String navigateTo;

  @override
  State<StatefulWidget> createState() {
    return _HoveredTextState();
  }
}

class _HoveredTextState extends State<HoveredText> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovered) {
        setState(() => isHovering = hovered);
      },
      onTap: () => GoRouter.of(context).go(widget.navigateTo),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(
            bottom: isHovering
                ? BorderSide(color: widget.underlineColor)
                : BorderSide.none,
          ),
        ),
        child: Text(
          widget.text,
          style: widget.textStyle,
        ),
      ),
    );
  }
}
