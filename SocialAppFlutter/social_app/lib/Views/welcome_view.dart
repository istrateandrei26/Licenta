import 'package:flutter/material.dart';
import 'package:social_app/Views/login_register_choice_view.dart';
import 'package:social_app/utilities/constants.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Image.asset("assets/images/welcome_image.png"),
            const Spacer(flex: 3,),
            Text(
              "Welcome to our freedom \nsport network",
              textAlign: TextAlign.center,
              style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              "Freedom organize activities of your \nfriends circle",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                .textTheme.bodyText1?.color?.withOpacity(0.6)
              ),
            ),
            const Spacer(flex: 3,),
            FittedBox(
              child: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginRegisterChoiceView())),
                child: Row(
                  children: [
                    Text(
                      "Skip",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context)
                        .textTheme
                        .bodyText1?.color?.withOpacity(0.8)),
                      ),
                    const SizedBox(width: kDefaultPadding / 4,),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.8),
                    )
                  ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}