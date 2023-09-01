import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class BasicOverlayWidget extends StatefulWidget {
  final CachedVideoPlayerController controller;
  const BasicOverlayWidget({super.key, required this.controller});

  @override
  State<BasicOverlayWidget> createState() => _BasicOverlayWidgetState();
}

class _BasicOverlayWidgetState extends State<BasicOverlayWidget> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
          });
        },
        child: Stack(
          children: <Widget>[
            Visibility(
            visible: !widget.controller.value.isPlaying,
            child: Container(
                alignment: Alignment.center,
                color: Colors.black26,
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
              ),
          ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildIndicator(),
            ),
          ],
        ),
      );

  Widget buildIndicator() => VideoProgressIndicator(
        widget.controller,
        allowScrubbing: true,
      ); 
}
