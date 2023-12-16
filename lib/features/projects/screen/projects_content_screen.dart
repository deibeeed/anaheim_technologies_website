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
  const MasterDetailScreen({
    super.key,
    required this.title,
    required this.titleList,
    required this.detailList,
    this.narrativeList = const [],
    this.showAllTitleList = false,
    this.detailListPaddingTop,
    this.filledIndicator = false,
  });

  final String title;
  final List<String> titleList;
  final List<String> narrativeList;
  final List<Widget> detailList;
  final bool showAllTitleList;
  final double? detailListPaddingTop;
  final bool filledIndicator;

  @override
  State<StatefulWidget> createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetailScreen> {
  int? showingIndex;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontFamily: 'Mechsuit', fontSize: 24),
        ),
        const SizedBox(
          height: 32,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...widget.titleList.mapIndexed((index, element) {
                      return Visibility(
                          visible: widget.showAllTitleList
                              ? true
                              : showingIndex == null || showingIndex == index,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: SizedBox(
                              width: widget.filledIndicator
                                  ? double.infinity
                                  : null,
                              child: HoveredText(
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
                                textStyle: const TextStyle(
                                  fontFamily: 'Plavsky',
                                  fontSize: 24,
                                ),
                                filledIndicator: widget.filledIndicator,
                              ),
                            ),
                          ));
                    }),
                    if (showingIndex != null &&
                        widget.narrativeList.isNotEmpty) ...[
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: WidgetUtils.showDetailNarrative(
                          context: context,
                          detailText: widget.narrativeList[showingIndex!],
                        ),
                      )),
                    ]
                  ],
                ),
              ),
              if (showingIndex != null && widget.detailList.isNotEmpty) ...[
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
          ),
        )
      ],
    );
  }


}
