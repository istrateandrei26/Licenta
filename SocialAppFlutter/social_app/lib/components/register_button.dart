import 'package:flutter/material.dart';
import 'package:social_app/utilities/constants.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding),
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
