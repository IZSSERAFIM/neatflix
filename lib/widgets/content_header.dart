import 'package:flutter/material.dart';
import 'package:neatflix/models/content_model.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:neatflix/screens/screens.dart';

class ContentHeader extends StatelessWidget {
  const ContentHeader({
    Key? key,
    required this.featuredContent,
  }) : super(key: key);
  final Content featuredContent;
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _ContentHeaderMobile(featuredContent),
      desktop: _ContentHeaderDesktop(featuredContent),
    );
  }
}

class _ContentHeaderMobile extends StatefulWidget {
  final Content featuredContent;
  const _ContentHeaderMobile(this.featuredContent);

  @override
  State<_ContentHeaderMobile> createState() => _ContentHeaderMobileState();
}

class _ContentHeaderMobileState extends State<_ContentHeaderMobile> {
  late VideoPlayerController _videoController;
  ValueNotifier<bool> _isPlayingNotifier;

  _ContentHeaderMobileState() : _isPlayingNotifier = ValueNotifier(true);

  void _togglePlayPause() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.featuredContent.videoUrl!))
      ..initialize().then((_) {
        _isPlayingNotifier.value = _videoController.value.isPlaying;
        setState(() {});
      })
      ..pause();
    _videoController.addListener(() {
      if (mounted) {
        setState(() {
          _isPlayingNotifier.value = _videoController.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _isPlayingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _isPlayingNotifier,
          builder: (context, isPlaying, child) {
            return AspectRatio(
              aspectRatio: _videoController.value.isInitialized
                  ? (isPlaying ? _videoController.value.aspectRatio : 1)
                  : 1,
              child: isPlaying
                  ? VideoPlayer(_videoController)
                  : Image.asset(
                      widget.featuredContent.imageUrl,
                      fit: BoxFit.cover,
                    ),
            );
          },
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: -1.0,
          child: AspectRatio(
            aspectRatio: _videoController.value.isInitialized
                ? _videoController.value.aspectRatio
                : 1,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 110.0,
          child: SizedBox(
            width: 250.0,
            child: Image.asset(widget.featuredContent.titleImageUrl!),
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VerticalIconButton(
                icon: Icons.add,
                title: 'List',
                onTap: () {},
              ),
              _PlayButton(
                onPressed: _togglePlayPause,
                isPlayingNotifier: _isPlayingNotifier,
              ),
              VerticalIconButton(
                icon: Icons.info_outline,
                title: 'Info',
                onTap: () {
                  _videoController.pause();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PlayerScreen(content: widget.featuredContent),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentHeaderDesktop extends StatefulWidget {
  final Content featuredContent;
  const _ContentHeaderDesktop(this.featuredContent);

  @override
  State<_ContentHeaderDesktop> createState() => _ContentHeaderDesktopState();
}

class _ContentHeaderDesktopState extends State<_ContentHeaderDesktop> {
  late VideoPlayerController _videoController;
  bool _isMuted = true;
  ValueNotifier<bool> _isPlayingNotifier;

  _ContentHeaderDesktopState() : _isPlayingNotifier = ValueNotifier(true);

  void _togglePlayPause() {
    _isPlayingNotifier.value = !_videoController.value.isPlaying;
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.featuredContent.videoUrl!))
      ..initialize().then((_) {
        _isPlayingNotifier.value = _videoController.value.isPlaying;
        setState(() {});
      })
      ..setVolume(0)
      ..play();
    _videoController.addListener(() {
      if (_videoController.value.isPlaying != _isPlayingNotifier.value) {
        _isPlayingNotifier.value = _videoController.value.isPlaying;
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _isPlayingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _videoController.value.isPlaying
          ? _videoController.pause()
          : _videoController.play(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          AspectRatio(
            aspectRatio: _videoController.value.isInitialized
                ? _videoController.value.aspectRatio
                : 2.344,
            child: _videoController.value.isInitialized
                ? VideoPlayer(_videoController)
                : Image.asset(
                    widget.featuredContent.imageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: -1.0,
            child: AspectRatio(
              aspectRatio: _videoController.value.isInitialized
                  ? _videoController.value.aspectRatio
                  : 2.344,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 60.0,
            right: 60.0,
            bottom: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250.0,
                  child: Image.asset(widget.featuredContent.titleImageUrl!),
                ),
                const SizedBox(height: 15.0),
                Text(
                  widget.featuredContent.description!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2.0, 4.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    _PlayButton(
                      onPressed: _togglePlayPause,
                      isPlayingNotifier: _isPlayingNotifier,
                    ),
                    const SizedBox(width: 16.0),
                    TextButton.icon(
                      onPressed: () {
                        _videoController.pause();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayerScreen(content: widget.featuredContent),
                          ),
                        );
                      },
                      icon: Icon(Icons.info_outline, size: 30.0),
                      label: const Text(
                        'More Info',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    if (_videoController.value.isInitialized)
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                        ),
                        color: Colors.white,
                        iconSize: 30.0,
                        onPressed: () => setState(
                          () {
                            _isMuted
                                ? _videoController.setVolume(100)
                                : _videoController.setVolume(0);
                            _isMuted = !_isMuted;
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ValueNotifier<bool> isPlayingNotifier;

  const _PlayButton(
      {Key? key, required this.onPressed, required this.isPlayingNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isPlayingNotifier,
      builder: (context, isPlaying, _) {
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            padding: !Responsive.isDesktop(context)
                ? const EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0)
                : const EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 30.0,
                color: Colors.black,
              ),
              SizedBox(width: 8.0),
              Text(
                isPlaying ? 'Pause' : 'Play',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
