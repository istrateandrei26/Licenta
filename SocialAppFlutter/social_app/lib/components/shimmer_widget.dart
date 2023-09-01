import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular(
      {super.key, this.width = double.infinity, required this.height}) : this.shapeBorder = const RoundedRectangleBorder();
  const ShimmerWidget.circular(
      {super.key, required this.width, required this.height, this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      baseColor: Colors.blue[100]!,
      highlightColor: Colors.blue[50]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey,
          shape: shapeBorder
        ),
      ),
    );
  }
}
