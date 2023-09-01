import 'package:flutter/material.dart';
import 'package:social_app/utilities/constants.dart';

class ButtonProgressIndicator extends StatelessWidget {
  const ButtonProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: kDefaultPadding,
            right: kDefaultPadding,
            top: kDefaultPadding * 3),
        alignment: Alignment.center,
        height: kDefaultPadding * 2,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const SizedBox(
          height: kDefaultPadding,
          width: kDefaultPadding,
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
            strokeWidth: 2,
          ),
        ));
  }
}
