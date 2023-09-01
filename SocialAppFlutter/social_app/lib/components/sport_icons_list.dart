import 'package:flutter/material.dart';

List<SportCategoryIconWidget> icon_list = [
  SportCategoryIconWidget(
    iconPath: "assets/icons/football.png",
    id: 1,
    requiredMembers: const [10, 12],
  ),
  SportCategoryIconWidget(
    iconPath: "assets/icons/tennis.png",
    id: 3,
    requiredMembers: const [2, 4],
  ),
  SportCategoryIconWidget(
    iconPath: "assets/icons/hockey.png",
    id: 6,
    requiredMembers: const [10, 12, 20, 24],
  ),
  SportCategoryIconWidget(
    iconPath: "assets/icons/handball.png",
    id: 9,
    requiredMembers: const [7],
  ),
  SportCategoryIconWidget(
    iconPath: "assets/icons/volley.png",
    id: 8,
    requiredMembers: const [6, 8, 12],
  ),
  SportCategoryIconWidget(
    iconPath: "assets/icons/swim.png",
    id: 11,
    requiredMembers: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  ),
  SportCategoryIconWidget(
    iconPath: "assets/icons/ping-pong.png",
    id: 7,
    requiredMembers: const [2, 4],
  ),
  SportCategoryIconWidget(
    iconPath: "assets/icons/basketball.png",
    id: 2,
    requiredMembers: const [8, 10, 12],
  ),
];

Widget getMatchingIconForSportCategory(String sportCategory, double size) {
  switch (sportCategory) {
    case "Football":
      return Image.asset("assets/icons/football.png",
          width: size,
          height: size,
      );
    case "Basketball":
      return Image.asset("assets/icons/basketball.png",
          width: size,
          height: size,
      );
    case "Ping Pong":
      return Image.asset("assets/icons/ping-pong.png",
          width: size,
          height: size,
      );
    case "Hockey":
      return Image.asset("assets/icons/hockey.png",
          width: size,
          height: size,
      );
    case "Swim":
      return Image.asset("assets/icons/swim.png",
          width: size,
          height: size,
      );
    case "Volley":
      return Image.asset("assets/icons/volley.png",
          width: size,
          height: size,
      );
    case "Handball":
      return Image.asset("assets/icons/handball.png",
          width: size,
          height: size,
      );
    case "Tennis":
      return Image.asset("assets/icons/tennis.png",
          width: size,
          height: size,
      );

    default:
      return const Icon(Icons.error_outline, color: Colors.red);
  }
}

// ignore: must_be_immutable
class SportCategoryIconWidget extends StatefulWidget {
  String iconPath;
  int id;
  List<int> requiredMembers;

  SportCategoryIconWidget(
      {Key? key,
      required this.iconPath,
      required this.id,
      required this.requiredMembers})
      : super(key: key);

  @override
  State<SportCategoryIconWidget> createState() =>
      _SportCategoryIconWidgetState();
}

class _SportCategoryIconWidgetState extends State<SportCategoryIconWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotatedBox(
        quarterTurns: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 80,
            height: 80,
            color: Colors.blue[100],
            padding: const EdgeInsets.all(20),
            child: Center(child: Image.asset(widget.iconPath)),
          ),
        ),
      ),
    );
  }
}
