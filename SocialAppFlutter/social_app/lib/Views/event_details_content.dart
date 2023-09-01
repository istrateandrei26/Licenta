import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Models/event_details.dart';

class EventDetailsContent extends StatelessWidget {
  const EventDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final EventDetails eventDetails = Provider.of<EventDetails>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
            child: Text(
              eventDetails.event!.location.city,
              style: const TextStyle(
                fontSize: 38.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
            child: Row(
              children: <Widget>[
                const Text(
                  "-",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    eventDetails.event!.location.locationName,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "${AppLocalizations.of(context)!.event_details_view_guests_text} ${eventDetails.members.length}/${eventDetails.event!.requiredMembersTotal}",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (var member in eventDetails.members)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/${member.profileImage}",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: Text(AppLocalizations.of(context)!.event_details_view_welcome_text).data,
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFF4700),
                    )),
                TextSpan(
                    text: Text(AppLocalizations.of(context)!.event_details_view_best_match)
                        .data,
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ))
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.event_details_view_guest_fills,
              style: TextStyle(
                fontSize: 20.0,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
