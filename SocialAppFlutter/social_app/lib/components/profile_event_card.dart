import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:social_app/components/sport_icons_list.dart';

import '../Models/user.dart';

class ProfileEventCard extends StatelessWidget {
  ProfileEventCard(
      {Key? key,
      required this.city,
      required this.locationName,
      required this.datetime,
      required this.duration,
      required this.average,
      required this.sportCategory, required this.members})
      : super(key: key);

  final String city;
  final String locationName;
  final DateTime datetime;
  final double duration;
  final double average;
  final List<User> members;
  String? sportCategory;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: const Color.fromARGB(255, 20, 79, 128),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Color.fromARGB(255, 20, 79, 128),
                      size: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(formatDate(datetime, [
                      dd,
                      '-',
                      mm,
                      '-',
                      yyyy,
                    ]), style: TextStyle(fontSize: 12),),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled_sharp,
                      color: Color.fromARGB(255, 20, 79, 128),
                      size: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("${formatDate(datetime, [
                          HH,
                          ':',
                          nn
                        ])} - ${formatDate(datetime.add(Duration(minutes: duration.toInt())), [
                          HH,
                          ':',
                          nn
                        ])}",style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_city,
                      color: Color.fromARGB(255, 20, 79, 128),
                      size: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(city.trim(),style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 20, 79, 128),
                      size: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        locationName.trim(),
                        overflow: TextOverflow.clip,style: TextStyle(fontSize: 12)
                      ),
                    ),
                  ],
                  
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 2),
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: members.length,
                        itemBuilder:(context, index) => Column(children: [
                        members[index].profileImage == null ? 
                        CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.grey.shade700,
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 9,
                          ),
                        )
                        :
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: MemoryImage(
                                      Uint8List.fromList(members[index].profileImage!)),
                          radius: 9,
                        ), 
                        Text(members[index].firstname!, style: TextStyle(fontSize: 6),)
                          
                        ],) 
                      ),
                    )
              ],
            ),
            Column(
              children: [getMatchingIconForSportCategory(sportCategory!, average != -1 ? 30 : 30)],
            ),
            if(average != -1 && average != 0)
              Column(
                children: [
                  RatingBarIndicator(
                    unratedColor: Colors.amber,
                    rating: 5 - average,
                    itemCount: 5,
                    itemSize: 20,
                    direction: Axis.vertical,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    average.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 10),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
