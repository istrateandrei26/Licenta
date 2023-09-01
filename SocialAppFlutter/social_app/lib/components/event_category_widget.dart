import 'package:flutter/material.dart';
import 'package:social_app/Models/sport_category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventCategoryWidget extends StatefulWidget {
  EventCategoryWidget(
      {super.key,
      required this.item,
      required this.onTap,
      required this.selected});

  final SportCategory item;
  final VoidCallback onTap;
  bool selected = false;

  @override
  State<EventCategoryWidget> createState() => _EventCategoryWidgetState();
}

class _EventCategoryWidgetState extends State<EventCategoryWidget> {
  Image drawIcon(String sportCategory, width, height) {
    switch (sportCategory) {
      case "Football":
        return Image.asset('assets/icons/football.png',
            width: width, height: height);
      case "Basketball":
        return Image.asset('assets/icons/basketball.png',
            width: width, height: height);
      case "Tennis":
        return Image.asset('assets/icons/tennis.png',
            width: width, height: height);
      case "Hockey":
        return Image.asset('assets/icons/hockey.png',
            width: width, height: height);
      case "Ping Pong":
        return Image.asset('assets/icons/ping-pong.png',
            width: width, height: height);
      case "Volley":
        return Image.asset('assets/icons/volley.png',
            width: width, height: height);
      case "Handball":
        return Image.asset('assets/icons/handball.png',
            width: width, height: height);
      case "Futsal":
        return Image.asset('assets/icons/futsal.png',
            width: width, height: height);
      case "Swim":
        return Image.asset('assets/icons/swim.png',
            width: width, height: height);
      default:
        return Image.asset('assets/icons/search.png',
            width: width, height: height);
    }
  }

  String getCategoryText(String sportCategory) {
    switch (sportCategory) {
      case "Football":
        return AppLocalizations.of(context)!.category_football_text;
      case "Basketball":
        return AppLocalizations.of(context)!.category_basketball_text;
      case "Tennis":
        return AppLocalizations.of(context)!.category_tennis_text;
      case "Hockey":
        return AppLocalizations.of(context)!.category_hockey_text;
      case "Ping Pong":
        return AppLocalizations.of(context)!.category_ping_pong_text;
      case "Volley":
        return AppLocalizations.of(context)!.category_volleyball_text;
      case "Handball":
        return AppLocalizations.of(context)!.category_handball_text;
      case "Futsal":
        return AppLocalizations.of(context)!.category_futsal_text;
      case "Swim":
        return AppLocalizations.of(context)!.category_swim_text;
      default:
        return AppLocalizations.of(context)!.category_all_text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: widget.selected
                ? const Color.fromARGB(255, 4, 40, 94)
                : Colors.transparent),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                onPressed: widget.onTap,
                icon: drawIcon(widget.item.name, 25.0, 25.0)),
            Text(
              getCategoryText(widget.item.name),
              style: const TextStyle(color: Colors.white, fontSize: 8),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
