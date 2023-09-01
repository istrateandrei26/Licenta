import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoConnectionView extends StatelessWidget {
  const NoConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                                      "assets/images/logo_image.png"),
              Icon(Icons.signal_cellular_connected_no_internet_0_bar_outlined, color: Colors.red, size: MediaQuery.of(context).size.width * 0.3,),
              Text(AppLocalizations.of(context)!.internet_sheet_no_connectivity_message, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
    );
  }
}