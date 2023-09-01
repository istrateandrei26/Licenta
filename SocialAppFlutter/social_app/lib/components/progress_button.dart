import 'package:flutter/material.dart';
import 'package:social_app/components/animated_indicator.dart';
import 'package:social_app/utilities/constants.dart';

class ProgressButton extends StatelessWidget {
  final bool isAnimated;
  final VoidCallback onNext;
  const ProgressButton(
      {Key? key, required this.onNext, required this.isAnimated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: Stack(children: [
        if (isAnimated)
          AnimatedIndicator(
            duration: const Duration(seconds: 5),
            size: 75,
            callback: onNext,
          ),
        Center(
          child: GestureDetector(
            onTap: onNext,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: kPrimaryColor),
              child: const Center(
                  child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              )),
            ),
          ),
        )
      ]),
    );
  }
}