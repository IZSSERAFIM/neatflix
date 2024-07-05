import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class HeaderPlayer extends StatefulWidget {
  final String VideoUrl;

  const HeaderPlayer({Key? key, required this.VideoUrl}) : super(key: key);

  @override
  State<HeaderPlayer> createState() => _HeaderPlayerState();
}

class _HeaderPlayerState extends State<HeaderPlayer> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.VideoUrl));
    videoPlayerController.initialize().then((_) {
      setState(() {});
    });

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: chewieController.videoPlayerController.value.aspectRatio,
      child: Center(
        child: chewieController.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: chewieController,
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
