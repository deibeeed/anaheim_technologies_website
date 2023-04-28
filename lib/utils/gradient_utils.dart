import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:flutter/material.dart';

class GradientUtils {
  static final extendedGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.gradientTop.withOpacity(0.4),
        AppColors.gradientBottom.withOpacity(0.4),
        AppColors.gradientBottom.withOpacity(0.4),
        AppColors.gradientTop.withOpacity(0.4),
      ],
    stops: const [
      0.0,
      0.2,
      0.8,
      1.0
    ]
  );

  static final singleGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.gradientTop.withOpacity(0.4),
        AppColors.gradientBottom.withOpacity(0.4),
      ],
    stops: const [
      0.0,
      0.4,
    ],
  );
}