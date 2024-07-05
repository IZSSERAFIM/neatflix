import 'package:flutter/material.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:neatflix/data/data.dart';

class VideoDescription extends StatelessWidget {
  const VideoDescription({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _VideoDescriptionMobile(
        title: title,
        description: description,
      ),
      desktop: _VideoDescriptionMobile(
        title: title,
        description: description,
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
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoDescriptionDesktop extends StatefulWidget {
  const _VideoDescriptionDesktop(
      {Key? key, required this.title, required this.description})
      : super(key: key);
  final String title;
  final String description;
  @override
  State<_VideoDescriptionDesktop> createState() =>
      _VideoDescriptionDesktopState();
}

class _VideoDescriptionDesktopState extends State<_VideoDescriptionDesktop> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
