import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/google/google_sign_in_service.dart';
import '../utilities/constants.dart';

class GoogleSignInButton extends StatelessWidget {
  final String text;
  const GoogleSignInButton({
    Key? key, required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
      ),
      alignment: Alignment.center,
      height: kDefaultPadding * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton.icon(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 50)),
            elevation: MaterialStateProperty.all(4)),
        label: Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.google,
          color: Colors.red,
        ),
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInService>(context, listen: false);
          provider.googleLogin();
        },
      ),
    );
  }
}
