import 'package:flutter/material.dart';
import 'package:social_app/components/primary_button.dart';
import 'package:social_app/utilities/constants.dart';

class LoginRegisterChoiceView extends StatelessWidget {
  const LoginRegisterChoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset("assets/images/logo_image.png"),
              const Spacer(),
              PrimaryButton(
                text: "LogIn", 
                press: () {}
              ),
              const SizedBox(
                height: kDefaultPadding * 1.5,
              ),
              PrimaryButton(
                  color: Theme.of(context).colorScheme.secondary,
                  text: "Register",
                  press: () {}),
              const Spacer(
                flex: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
