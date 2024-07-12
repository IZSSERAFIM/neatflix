import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:neatflix/utils/utils.dart';

class NeatflixRatingBar extends StatefulWidget {
  const NeatflixRatingBar({Key? key, required this.videoId}) : super(key: key);
  final int videoId;

  @override
  State<NeatflixRatingBar> createState() => _NeatflixRatingBarState();
}

class _NeatflixRatingBarState extends State<NeatflixRatingBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Rate this video',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        RatingBar.builder(
          unratedColor: Colors.grey[700],
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) async {
            await rateVideo(widget.videoId, rating);
          },
        ),
      ],
    );
  }
}
