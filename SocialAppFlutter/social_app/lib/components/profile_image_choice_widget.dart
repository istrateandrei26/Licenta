import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ProfileImageChoiceWidget extends StatefulWidget {
  final Uint8List bytes;
  final AssetEntity asset;

  const ProfileImageChoiceWidget(
      {super.key,
      required this.bytes,
      required this.asset});

  @override
  State<ProfileImageChoiceWidget> createState() =>
      _ProfileImageChoiceWidgetState();
}

class _ProfileImageChoiceWidgetState extends State<ProfileImageChoiceWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned.fill(
        child: Opacity(
          opacity: 1,
          child: Image.memory(
            widget.bytes,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ]);
  }
}
