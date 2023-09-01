import 'package:flutter/material.dart';
import 'package:social_app/components/shimmer_widget.dart';

class ShimmerEventInviteItemWidget extends StatelessWidget {
  const ShimmerEventInviteItemWidget({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
    margin: const EdgeInsets.symmetric(
      horizontal: 10.0, vertical: 6.0),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: SizedBox(
                        width: screenHeight / 11,
                        height: screenHeight / 11,
                        child: AspectRatio(
    aspectRatio: 1.5,
    child: ShimmerWidget.rectangular(width: screenHeight / 11, height: screenHeight / 11),
                        ),
                      )),
          const SizedBox(width: 10),
          
          Column(
            children: [
              ShimmerWidget.rectangular(width: screenWidth * 0.4, height: 10),
              const SizedBox(height: 5),
              ShimmerWidget.rectangular(width: screenWidth * 0.4, height: 10),
              const SizedBox(height: 5),
              ShimmerWidget.rectangular(width: screenWidth * 0.4, height: 10),
              const SizedBox(height: 5),
              ShimmerWidget.rectangular(width: screenWidth * 0.4, height: 10),
              const SizedBox(height: 5),
              ShimmerWidget.rectangular(width: screenWidth * 0.4, height: 10),
            ],
          ),
          const Spacer(),
          const ShimmerWidget.rectangular(height: 30, width: 50,)
        ],
      ),
    ),
                        );
  }
}
