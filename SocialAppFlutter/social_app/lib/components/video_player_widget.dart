import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'basic_overlay_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  final CachedVideoPlayerController controller;
  const VideoPlayerWidget({super.key, required this.controller});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  Widget build(BuildContext context) => widget.controller.value.isInitialized
      ? Container(
        color: Colors.transparent,
          child: buildVideo(),
        )
      : SizedBox(
          height: MediaQuery.of(context).size.height * 0.3, width: MediaQuery.of(context).size.width * 0.35, child: Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Colors.white), strokeWidth: 2,)));

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
          Positioned.fill(child: BasicOverlayWidget(controller: widget.controller)),
        ],
      );

  Widget buildVideoPlayer() {
    final Size size = MediaQuery.of(context).size;
      final double videoWidth = widget.controller.value.size.width;
      final double videoHeight = widget.controller.value.size.height;
      final double aspectRatio = videoWidth / videoHeight;
    return Container(
      color: Colors.white,
      width: aspectRatio > 1 ? size.width : size.width * 0.35,
        height: aspectRatio > 1 ? size.height * 0.7 : size.height * 0.3,
      child: AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: CachedVideoPlayer(widget.controller),
      ),
    );
  }
}
