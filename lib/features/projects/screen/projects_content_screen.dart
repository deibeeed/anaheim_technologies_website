import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/print_utils.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProjectsContentScreen extends StatefulWidget {
  const ProjectsContentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProjectsContentState();
}

class _ProjectsContentState extends State<ProjectsContentScreen> {
  int? showingIndex;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Projects',
              style: TextStyle(fontFamily: 'Mechsuit', fontSize: 16),
            ),
            const SizedBox(
              height: 32,
            ),
            if (showingIndex == null || showingIndex == 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HoveredText(
                    text: 'BPV Loan Monitoring',
                    alwaysShowIndicator: showingIndex == 0,
                    onTap: () {
                      setState(() {
                        if (showingIndex != null) {
                          showingIndex = null;
                          return;
                        }

                        showingIndex = 0;
                      });
                    },
                  ),
                  Icon(
                    showingIndex == null
                        ? Icons.arrow_right_rounded
                        : Icons.arrow_drop_down_rounded,
                    color: AppColors.foregroundColor,
                  )
                ],
              ),
            if (showingIndex == null || showingIndex == 1)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HoveredText(
                    text: '[PROTOTYPE] HLP Systems',
                    alwaysShowIndicator: showingIndex == 1,
                    onTap: () {
                      setState(() {
                        if (showingIndex != null) {
                          showingIndex = null;
                          return;
                        }

                        showingIndex = 1;
                      });
                    },
                  ),
                  Icon(
                    showingIndex == null
                        ? Icons.arrow_right_rounded
                        : Icons.arrow_drop_down_rounded,
                    color: AppColors.foregroundColor,
                  )
                ],
              ),
            if (showingIndex != null) ...[
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _showDetailNarrative(index: showingIndex!),
              )
            ]
          ],
        ),
        if (showingIndex != null) ...[
          SizedBox(
            width: screenSize.width * 0.1,
          ),
          _showDetailMedia(
            index: showingIndex!,
            height: screenSize.height * 0.46,
            width: screenSize.width * 0.312,
          ),
        ],
      ],
    );
  }

  Widget _showDetailNarrative({
    required int index,
  }) {
    String detailText = '''BPV Loan monitoring is a loan monitoring application
created specific for the needs of Baybay Property
Ventures Corp.

The application is an internal company application
that monitors the loan of their customers. Providing
real time posting of payments when the customer
pays.

The application also tracks lots to determine which
lots are sold and which are not. 

Want to learn more about the application and 
how we can help you? ''';

    if (index == 1) {
      detailText = '''This customer, thru a mutual connection, was
having problems with his collections and 
remittances. Not because there’s a lack of
resources, but because of human intended 
errors.

The solution: Integrity, Accountability and 
Security.

We created an application of interconnected
systems that will help the customer monitor
and take actions to the accountable.

Want to learn more about the application and
how we can help you? ''';
    }

    return Text.rich(
      TextSpan(text: detailText, style: TextStyle(height: 1.5,), children: [
        TextSpan(
            text: 'Talk to us today!',
            style: const TextStyle(
              color: AppColors.textLinkColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                GoRouter.of(context).go('/hello');
              })
      ]),
    );
  }

  Widget _showDetailMedia({
    required int index,
    double height = 450.0,
    double width = 450,
  }) {
    Widget media = SvgPicture.asset(
      'assets/svg/3d-model.svg',
      colorFilter: const ColorFilter.mode(
        AppColors.textLinkColor,
        BlendMode.srcIn,
      ),
    );

    if (index == 0) {
      media = SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/pic1.png',
              height: height * 0.35,
            ),
            Positioned(
              top: height * 0.3,
              right: 0,
              child: Image.asset(
                'assets/images/pic2.png',
                height: height * 0.45,
              ),
            ),
            Positioned(
              top: height * 0.5,
              child: Image.asset(
                'assets/images/pic3.png',
                height: height * 0.35,
              ),
            ),
          ],
        ),
      );
    }

    return media;
  }
}
