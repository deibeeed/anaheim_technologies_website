import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/constants.dart';
import 'package:anaheim_technologies_website/utils/gradient_utils.dart';
import 'package:anaheim_technologies_website/utils/print_utils.dart';
import 'package:flutter/gestures.dart';
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

  static Widget showDetailNarrative({
    required BuildContext context,
    required String detailText,
  }) {
    return Text.rich(
      TextSpan(
          text: detailText,
          style: const TextStyle(
            height: 1.5,
          ),
          children: [
            //space
            TextSpan(text: ' '),
            TextSpan(
                text: 'Talk to us today!',
                style: const TextStyle(
                  color: AppColors.textLinkColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    GoRouter.of(context).go('/contact');
                  })
          ]),
    );
  }
}

class HoveredText extends StatefulWidget {
  const HoveredText({
    super.key,
    required this.text,
    this.navigateTo,
    this.onTap,
    this.textStyle = const TextStyle(fontFamily: 'Plavsky'),
    this.underlineColor = AppColors.foregroundColor,
    this.alwaysShowIndicator = false,
    this.filledIndicator = false,
  });

  final String text;
  final Color underlineColor;
  final TextStyle textStyle;
  final String? navigateTo;
  final bool alwaysShowIndicator;
  final VoidCallback? onTap;
  final bool filledIndicator;

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
      onTap: () {
        if (widget.navigateTo != null) {
          GoRouter.of(context).go(widget.navigateTo!);
        }

        if (widget.onTap != null) {
          widget.onTap?.call();
        }
      },
      child: Container(
        padding: EdgeInsets.all(widget.filledIndicator ? 16 : 4),
        decoration: BoxDecoration(
          border: widget.filledIndicator
              ? null
              : Border(
                  bottom: isHovering || widget.alwaysShowIndicator
                      ? BorderSide(color: widget.underlineColor)
                      : const BorderSide(color: Colors.transparent),
                ),
          color: !widget.filledIndicator
              ? null
              : widget.alwaysShowIndicator
                  ? AppColors.textLinkColor
                  : null,
          borderRadius: !widget.filledIndicator ? null : BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            topRight: !Constants.isExpandedScreen ? Radius.circular(8) : Radius.zero,
            bottomRight: !Constants.isExpandedScreen ? Radius.circular(8) : Radius.zero,
          )
        ),
        child: Text(
          widget.text,
          style: widget.textStyle.apply(
            color: !widget.filledIndicator
                ? null
                : widget.alwaysShowIndicator
                    ? AppColors.gradientBottom
                    : null,
          ),
        ),
      ),
    );
  }
}
