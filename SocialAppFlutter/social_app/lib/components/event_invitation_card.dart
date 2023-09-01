import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:social_app/Models/user.dart';
import 'package:social_app/utilities/constants.dart';

class EventInvitationCard extends StatefulWidget {
  EventInvitationCard({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.city,
    required this.locationName,
    required this.datetime,
    required this.invitedBy,
    required this.duration,
    required this.onPressed,
    required this.accepted,
    required this.image, required this.processing,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;

  final String city;
  final String locationName;
  final DateTime datetime;
  final User invitedBy;
  final double duration;
  final VoidCallback onPressed;
  bool accepted;
  final String image;
  final bool processing;

  @override
  State<EventInvitationCard> createState() => _EventInvitationCardState();
}

class _EventInvitationCardState extends State<EventInvitationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0, vertical: 6.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: widget.screenHeight / 11,
                      height: widget.screenHeight / 11,
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 20, 79, 128),
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: widget.screenWidth * 0.35,
                          child: Text(widget.locationName,
                              style:
                                  const TextStyle(overflow: TextOverflow.clip, fontSize: 10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_city,
                          color: Color.fromARGB(255, 20, 79, 128),
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(widget.city.trim(), style: TextStyle(fontSize: 10),),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Color.fromARGB(255, 20, 79, 128),
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(formatDate(
                            widget.datetime, [dd, '-', mm, '-', yyyy]), style: TextStyle(fontSize: 10),),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_filled_sharp,
                          color: Color.fromARGB(255, 20, 79, 128),
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text("${formatDate(widget.datetime, [
                              HH,
                              ':',
                              nn
                            ])} - ${formatDate(widget.datetime.add(Duration(minutes: widget.duration.toInt())), [
                              HH,
                              ':',
                              nn
                            ])}", style: TextStyle(fontSize: 10),),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 20, 79, 128),
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                            "${widget.invitedBy.firstname} ${widget.invitedBy.lastname}", style: TextStyle(fontSize: 10),),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                widget.accepted
                    ? const Icon(Icons.check_circle,
                        color: kPrimaryColor, size: 35)
                    : ElevatedButton(
                        onPressed: widget.onPressed,
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor)),
                        child: widget.processing
                            ? const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white)))
                            : const Text("Join", style: TextStyle(fontSize: 10),),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
