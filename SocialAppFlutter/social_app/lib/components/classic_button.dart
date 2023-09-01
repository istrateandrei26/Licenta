import 'package:flutter/material.dart';
import 'package:social_app/utilities/constants.dart';

class ClassicButton extends StatelessWidget {
  const ClassicButton({Key? key, required this.text}) : super(key: key);

  final String text;

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
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
