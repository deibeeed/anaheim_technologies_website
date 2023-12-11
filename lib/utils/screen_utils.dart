import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ScreenSize {
  /// phone screens
  compact,

  /// tablet screens
  medium,

  /// desktop screens
  expanded
}

const defaultPaddingSize = 16.0;
const defaultIconSize = 24.0;
const defaultRadiusSize = 16.0;
const defaultRadius = Radius.circular(defaultRadiusSize);
const defaultIconSize2 = Size(defaultIconSize, defaultIconSize);
int lastTapMenuPosition = 0;

/// gets the screen size of the current context
ScreenSize getScreenSize({required BuildContext context}) {
  final deviceWidth = MediaQuery.of(context).size.width;

  if (deviceWidth < 600) return ScreenSize.compact;
  if (deviceWidth < 840) return ScreenSize.medium;

  return ScreenSize.expanded;
}

/// returns true if the current platform/os is a android
/// or iOS
bool isMobilePlatform() {
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}