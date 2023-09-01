import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:social_app/Models/event.dart';

class EventItemCard extends StatelessWidget {
  const EventItemCard({super.key, required this.item, required this.onTap});

  final Event item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 20),
        elevation: 15,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Image.asset(
                    item.sportCategory.image,
                    height: 150,
                    fit: BoxFit.fitWidth,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                item.location.city,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              
                              ),
                              Spacer(),
                              Text(
                                "${formatDate(item.startDateTime, [HH, ':', nn])} - ${formatDate(item.startDateTime.add(Duration(minutes: item.duration.toInt())), [HH, ':', nn])}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    fontSize: 10),
                                textAlign: TextAlign.right,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  item.location.locationName,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 11),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
