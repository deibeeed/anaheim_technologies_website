import 'dart:ui';

import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/gradient_utils.dart';
import 'package:anaheim_technologies_website/utils/print_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    printd('size: $size');
    return Scaffold(
      body: SizedBox.expand(
        child: ColoredBox(
          color: Colors.black,
          child: Container(
            decoration: BoxDecoration(
              gradient: GradientUtils.singleGradient,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Website under construction. Please come back on a later time.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Image.asset('assets/under-construction-2.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
