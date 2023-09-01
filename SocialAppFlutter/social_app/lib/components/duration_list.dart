import 'package:flutter/material.dart';

List<DurationChoiceWidget> duration_list = [
  DurationChoiceWidget(text: "30 min", minutes: 30,),
  DurationChoiceWidget(text: "1 h", minutes: 60,),
  DurationChoiceWidget(text: "1h 30 min", minutes: 90,),
];

class DurationChoiceWidget extends StatelessWidget {
  String text;
  double minutes;
  DurationChoiceWidget({
    Key? key, required this.text, required this.minutes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: const TextStyle(fontSize: 12)));
  }
}
