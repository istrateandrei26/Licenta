import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class LocalImageWidget extends StatefulWidget {
  final ValueChanged<bool> isSelected;
  final Uint8List bytes;
  final AssetEntity asset;

  const LocalImageWidget(
      {super.key,
      required this.bytes,
      required this.asset,
      required this.isSelected});

  @override
  State<LocalImageWidget> createState() => _LocalImageWidgetState();
}

class _LocalImageWidgetState extends State<LocalImageWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      }),
      child: Stack(children: <Widget>[
          Positioned.fill(
            child: Opacity(
              opacity: isSelected ? 0.7 : 1,
              child: Image.memory(
                widget.bytes,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if(isSelected) 
            const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(right: 5, bottom: 5),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 10,
                    child: Icon(Icons.check, size: 10, color: Colors.white,),
                  ),
                ),
              ),
          if (widget.asset.type == AssetType.video)
            const Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 5, bottom: 5),
                child: Icon(Icons.videocam, color: Colors.white),
              ),
            )
        ]),
    );
  }
}
