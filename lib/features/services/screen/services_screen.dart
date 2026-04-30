import 'package:anaheim_technologies_website/features/projects/screen/projects_content_screen.dart';
import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/constants.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var screenHeight = size.height;
    var screenWidth = size.width;

    final pddNarrative =
        '''Imagine an idea sitting in a notes app. Now imagine it in your customers' hands six weeks from now.

We design, build, and ship products end-to-end — mobile apps in Flutter, web platforms, backend services in Go and Node, cloud infrastructure on Firebase and GCP. We start with a clear understanding of what the product actually needs to do (and what it doesn't — saying no early saves months later). Then we build, ship, and iterate.

No theatrical strategy decks. No 6-month "discovery phases." Real working software, fast.''';

    final prototypingNarrative =
        '''Some products can't live entirely on a screen. Sensors, devices, embedded firmware — the work most software shops won't touch and most hardware shops can't ship — that's where we shine.

We design and prototype IoT systems end-to-end: hardware selection, firmware, LoRaWAN and other connectivity protocols, cloud ingestion, and the mobile or web apps that make the data useful. Seven years of doing this at scale at GlacierGrid (YC-backed IoT) means we know what breaks in production — and we design around it from day one.

If your product needs to live in the physical world, let's talk.''';

    final virtualTeamsNarrative =
        '''Building a team is hard. Finding the right people, running interviews, onboarding, managing — it's a job on top of the job you already have.

We help businesses build and run remote engineering teams without the administrative overhead. We handle talent sourcing, technical vetting, onboarding, and ongoing engineering oversight. Your culture stays yours. Your hiring pain becomes ours.

Whether you need one senior engineer or a full pod, we build remote teams optimized for the work — not the headcount.''';

    final brandingNarrative =
        '''Your brand is the first thing customers see and the last thing they remember.

We design digital identities that look the part and hold up under scale — logo, color, typography, motion, and the system that ties them all together. Whether you're a founder establishing a new identity or an established business refreshing one, we treat branding as engineering: consistent, documented, and built to last.''';

    if (!Constants.isExpandedScreen) {
      return MasterDetailScreen(
        detailListPaddingTop: screenHeight * 0.03,
        showAllTitleList: false,
        title: 'Services',
        titleList: const [
          'Branding',
          'Product design and development',
          'Prototyping',
          'Virtual teams',
        ],
        filledIndicator: true,
        narrativeList: [
          brandingNarrative,
          pddNarrative,
          prototypingNarrative,
          virtualTeamsNarrative,
        ],
        detailList: [],
      );
    }

    return MasterDetailScreen(
      detailListPaddingTop: screenHeight * 0.03,
      showAllTitleList: true,
      title: 'Services',
      titleList: const [
        'Branding',
        'Product design and development',
        'Prototyping',
        'Virtual teams',
      ],
      filledIndicator: true,
      detailList: [
        SizedBox(
          width: screenWidth * 0.3,
          child: WidgetUtils.showDetailNarrative(
            context: context,
            detailText: brandingNarrative,
          ),
        ),
        SizedBox(
          width: screenWidth * 0.3,
          child: WidgetUtils.showDetailNarrative(
            context: context,
            detailText: pddNarrative,
          ),
        ),
        SizedBox(
          width: screenWidth * 0.3,
          child: WidgetUtils.showDetailNarrative(
            context: context,
            detailText: prototypingNarrative,
          ),
        ),
        SizedBox(
          width: screenWidth * 0.3,
          child: WidgetUtils.showDetailNarrative(
            context: context,
            detailText: virtualTeamsNarrative,
          ),
        ),
      ],
    );
  }
}
