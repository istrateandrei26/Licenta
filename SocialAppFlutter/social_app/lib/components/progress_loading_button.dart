import 'package:flutter/material.dart';
import 'package:social_app/utilities/constants.dart';

class ProgressLoadingButton extends StatelessWidget {
  const ProgressLoadingButton(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: Stack(children: [
        Center(
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: kPrimaryColor),
            child: const Center(
                child: SizedBox(width: 20, height: 20 , child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Colors.white), strokeWidth: 2.0))
            ),
          ),
        )
      ]),
    );
  }
}