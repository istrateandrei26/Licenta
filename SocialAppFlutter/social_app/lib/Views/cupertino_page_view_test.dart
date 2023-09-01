
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/progress_button.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CupertinoTestView extends StatefulWidget {
  const CupertinoTestView({super.key});

  @override
  State<CupertinoTestView> createState() => _CupertinoTestViewState();
}

class _CupertinoTestViewState extends State<CupertinoTestView> {
  PageController pageController = PageController(initialPage: 0);

  final FixedExtentScrollController _testController =
      FixedExtentScrollController(
          initialItem: 1);
  final FixedExtentScrollController _testController1 =
      FixedExtentScrollController(
          initialItem: 0);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Image.asset("assets/images/competition.png")),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .create_event_view_event_creator_text,
                        style: kTitleStyle.copyWith(fontSize: 22),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .create_event_view_outreach,
                        style: kSubtitleStyle.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      ProgressButton(
                        onNext: nextPage,
                        isAnimated: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                )
              ],
            ),
            Column(
              children: [
                ActionPageButton(
                  onTap: previousPage,
                  canQuit: true,
                  canGoBack: true,
                ),
                const SizedBox(height: 20),
                Image.asset("assets/images/map.png",
                    width: screenWidth * 0.8, height: screenHeight * 0.3),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                          AppLocalizations.of(context)!
                              .create_event_view_choose_city,
                          style: kTitleStyle.copyWith(fontSize: 22)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          AppLocalizations.of(context)!
                              .create_event_view_enjoy_wherever,
                          style: kSubtitleStyle.copyWith(fontSize: 18)),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                        height: 300,
                        child: CupertinoPicker(
                            scrollController: _testController,
                            itemExtent: 64,
                            diameterRatio: 10.1,
                            onSelectedItemChanged: (value) {},
                            selectionOverlay:
                                CupertinoPickerDefaultSelectionOverlay(
                              background: Colors.blue.withOpacity(0.12),
                            ),
                            children: [
                              Text('0'),
                              Text('1'),
                              Text('2'),
                            ])),
                  ),
                ),
                ProgressButton(
                  onNext: () {
                    nextPage();
                  },
                  isAnimated: false,
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
            Column(
              children: [
                ActionPageButton(
                  onTap: previousPage,
                  canQuit: true,
                  canGoBack: true,
                ),
                Image.asset("assets/images/location.png",
                    width: screenWidth * 0.8, height: screenHeight * 0.4),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                          AppLocalizations.of(context)!
                              .create_event_view_choose_location,
                          style: kTitleStyle.copyWith(fontSize: 22)),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          AppLocalizations.of(context)!
                              .create_event_view_enjoy_wherever,
                          style: kSubtitleStyle.copyWith(fontSize: 18)),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                        height: 300,
                        child: CupertinoPicker(
                            scrollController: _testController1,
                            itemExtent: 64,
                            diameterRatio: 10.1,
                            onSelectedItemChanged: (value) {},
                            selectionOverlay:
                                CupertinoPickerDefaultSelectionOverlay(
                              background: Colors.blue.withOpacity(0.12),
                            ),
                            children: [
                              Text('4'),
                              Text('5'),
                              Text('6'),
                            ])),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  nextPage() {
    // setState(() {
      pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.linearToEaseOut);
    // });
  }

  void previousPage() {
    // setState(() {
      pageController.previousPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.linearToEaseOut);
    // });
  }
}

class ActionPageButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool canQuit;
  final bool canGoBack;
  const ActionPageButton({
    Key? key,
    required this.onTap,
    required this.canQuit,
    required this.canGoBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: canGoBack && canQuit
          ? MainAxisAlignment.spaceBetween
          : canGoBack
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
      children: [
        if (canGoBack)
          GestureDetector(
            onTap: onTap,
            child: Container(
                margin: const EdgeInsets.only(top: 15, left: 15),
                child: const Icon(Icons.arrow_back_ios)),
          ),
        if (canQuit)
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin: const EdgeInsets.only(top: 15, right: 15),
                child: const Icon(Icons.close)),
          ),
      ],
    );
  }
}

class Slide extends StatelessWidget {
  final Widget hero;
  final String title;
  final String subtitle;
  final VoidCallback onNext;
  final bool isButtonAnimated;

  const Slide(
      {Key? key,
      required this.hero,
      required this.title,
      required this.subtitle,
      required this.onNext,
      required this.isButtonAnimated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: hero),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                title,
                style: kTitleStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                subtitle,
                style: kSubtitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 35,
              ),
              ProgressButton(
                onNext: onNext,
                isAnimated: isButtonAnimated,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        )
      ],
    );
  }
}
