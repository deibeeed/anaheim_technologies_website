import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'About us',
            style: TextStyle(fontFamily: 'Mechsuit', fontSize: 24),
          ),
          const SizedBox(
            height: 32,
          ),
          Text.rich(
            TextSpan(
                text:
                '''We are  an Innovation Technology company that specializes on software design and development, that includes from frontend, Mobile, Web and desktop alike, to backend. We also specialize IoT (Internet of things) design and development prototyping. 

Our team believes that innovation should not come at a cost and that, technology should be enjoyed by everyone, young and old alike.

That’s why we do intensive interviews with our customers, trying to get even the smallest details so that we can empathize with them, as well as the users of their product.

One of our mission is to give everybody who is very interested in software development as a  career a chance to try being one so that they will have the experience and we will be able to help them decide if they really want to pursue the art of software development or not.

We are ready to be your partners in creating solutions to your software development and IoT prototyping needs.

Let us help you. ''',
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 16,
                ),
                children: [
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
          ),
        ],
      ),
      SizedBox(
        height: 500,
        child: Wrap(
          spacing: 32,
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 32,
          children: [
            'flutter_logo.svg',
            'dart_logo.svg',
            'firebase_logo.svg',
            'gcp_logo_full.svg',
            'golang_logo.svg',
            'java_logo_full.svg',
            'kotlin_logo.svg',
            'nodejs_logo.svg',
            'python_logo.svg',
            'swift_logo.svg',
            'typescript_logo.svg',
            'cpp_logo.svg',
            'gcp_iot_core_log.svg',
            'lorawan_logo_dark.svg',
          ].map((e) => SvgPicture.asset('assets/svg/$e', height: 56,)).toList(),
        ),
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {

      return SingleChildScrollView(
        child: Constants.isExpandedScreen ? Row(
          children: [
            Expanded(
              child: children[0],
            ),
            const Gap(32),
            Expanded(
              child: children[1],)
          ],
        ) : Column(
          children: [
            children[0],
            const Gap(32),
            children[1],
          ],
        ),
      );
    });
  }
}
