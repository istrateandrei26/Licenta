import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/video_player_widget.dart';

/// Stateful widget to fetch and then display video content.
class NetworkPlayerWidget extends StatefulWidget {
  final MainAxisAlignment alignment;
  final String videoUrl;

  const NetworkPlayerWidget({Key? key, required this.alignment, required this.videoUrl})
      : super(key: key);

  @override
  State<NetworkPlayerWidget> createState() => _NetworkPlayerWidgetState();
}

class _NetworkPlayerWidgetState extends State<NetworkPlayerWidget> {
  late CachedVideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerController.network(
        widget.videoUrl)
      ..setLooping(true)  
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: widget.alignment,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                VideoPlayerWidget(
                  controller: _controller,
                ),
              ],
            ),
          ),
        ],
      );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
