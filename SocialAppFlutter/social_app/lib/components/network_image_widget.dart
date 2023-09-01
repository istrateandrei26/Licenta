import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  const NetworkImageWidget(
      {super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    
      return
        CachedNetworkImage(
          imageUrl: imageUrl,
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.35,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.low,
          progressIndicatorBuilder: (context, url, progress) => 
          Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator.adaptive(value: progress.progress,),
              ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
  }
}
