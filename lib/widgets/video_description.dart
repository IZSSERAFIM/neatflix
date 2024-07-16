import 'package:flutter/material.dart';
import 'package:neatflix/utils/URL.dart';
import 'package:neatflix/widgets/widgets.dart';

class VideoDescription extends StatelessWidget {
  const VideoDescription({
    Key? key,
    this.title,
    this.description,
    this.titleImageUrl,
  }) : super(key: key);
  final String? title;
  final String? description;
  final String? titleImageUrl;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _VideoDescriptionMobile(
        title: title ?? '',
        description: description ?? '',
      ),
      desktop: _VideoDescriptionDesktop(
        titleImageUrl: titleImageUrl ?? '',
      ),
    );
  }
}

class _VideoDescriptionMobile extends StatefulWidget {
  const _VideoDescriptionMobile(
      {Key? key, required this.title, required this.description})
      : super(key: key);
  final String title;
  final String description;

  @override
  State<_VideoDescriptionMobile> createState() =>
      _VideoDescriptionMobileState();
}

class _VideoDescriptionMobileState extends State<_VideoDescriptionMobile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            widget.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoDescriptionDesktop extends StatefulWidget {
  const _VideoDescriptionDesktop({Key? key, required this.titleImageUrl})
      : super(key: key);
  final String titleImageUrl;

  @override
  State<_VideoDescriptionDesktop> createState() =>
      _VideoDescriptionDesktopState();
}

class _VideoDescriptionDesktopState extends State<_VideoDescriptionDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 7,
      child: Image.network(widget.titleImageUrl),
    );
  }
}
