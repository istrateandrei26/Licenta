import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../user_settings.dart/user_settings.dart';

class SelectDayWidget extends StatefulWidget {
  SelectDayWidget({Key? key, required this.onTap, required this.dayAdd, required this.selected})
      : super(key: key);

  final VoidCallback onTap;
  int dayAdd;
  bool selected = false;

  @override
  State<SelectDayWidget> createState() => _SelectDayWidgetState();
}

class _SelectDayWidgetState extends State<SelectDayWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime currentDatetime = DateTime.now().add(Duration(days: widget.dayAdd));
    // Color darkGrey = const Color.fromARGB(255, 4, 54, 6);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            border: widget.selected 
            ? const Border(
              bottom: BorderSide(color: Colors.black, width: 3),
            )
            : null,
            color: Colors.transparent),
        child: Column(children: [
          Text(DateFormat('EEEE', UserSettings.preferredLanguageCode).format(currentDatetime).substring(0, 3).toUpperCase(), style: TextStyle(color: widget.selected ? Colors.black : Colors.white, fontSize: 10,  fontWeight: FontWeight.bold),),
          const SizedBox(height: 4,),
          Text(
            DateFormat(
                    '${currentDatetime.day < 10 ? '0d' : 'd'}.${currentDatetime.month < 10 ? '0M' : 'M'}')
                .format(currentDatetime),
            style: TextStyle(color: widget.selected ? Colors.black : Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}
