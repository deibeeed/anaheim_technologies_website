import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/print_utils.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MasterDetailScreen extends StatefulWidget {
  const MasterDetailScreen(
      {super.key,
      required this.title,
      required this.titleList,
      required this.detailList,
      this.narrativeList = const [],
      this.showAllTitleList = false,
      this.detailListPaddingTop});

  final String title;
  final List<String> titleList;
  final List<String> narrativeList;
  final List<Widget> detailList;
  final bool showAllTitleList;
  final double? detailListPaddingTop;

  @override
  State<StatefulWidget> createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetailScreen> {
  int? showingIndex;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontFamily: 'Mechsuit', fontSize: 24),
              ),
              const SizedBox(
                height: 32,
              ),
              ...widget.titleList.mapIndexed((index, element) {
                return Visibility(
                    visible: widget.showAllTitleList
                        ? true
                        : showingIndex == null || showingIndex == index,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          HoveredText(
                            text: element,
                            alwaysShowIndicator: showingIndex == index,
                            onTap: () {
                              setState(() {
                                if (!widget.showAllTitleList &&
                                    showingIndex != null) {
                                  showingIndex = null;
                                  return;
                                }

                                showingIndex = index;
                              });
                            },
                          ),
                          if (widget.narrativeList.isNotEmpty)
                            Icon(
                              showingIndex != null
                                  ? Icons.arrow_right_rounded
                                  : Icons.arrow_drop_down_rounded,
                              color: AppColors.foregroundColor,
                            ),
                        ],
                      ),
                    ));
              }),
              if (showingIndex != null && widget.narrativeList.isNotEmpty) ...[
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _showDetailNarrative(
                    detailText: widget.narrativeList[showingIndex!],
                  ),
                ),
              ]
            ],
          ),
        ),
        if (showingIndex != null) ...[
          Gap(32),
          Expanded(
            child: Padding(
              padding: widget.detailListPaddingTop == null
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      top: widget.detailListPaddingTop!,
                    ),
              child: widget.detailList[showingIndex!],
            ),
          ),
        ],
      ],
    );
  }

  Widget _showDetailNarrative({
    required String detailText,
  }) {
    return Text.rich(
      TextSpan(
          text: detailText,
          style: const TextStyle(
            height: 1.5,
          ),
          children: [
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
}
