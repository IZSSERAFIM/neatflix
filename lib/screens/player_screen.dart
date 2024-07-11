import 'package:flutter/material.dart';
import 'package:neatflix/models/models.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:neatflix/utils/utils.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key, required this.content}) : super(key: key);
  final Content content;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _PlayerScreenMobile(
        content: content,
      ),
      desktop: _PlayerScreenDesktop(
        content: content,
      ),
    );
  }
}

class _PlayerScreenMobile extends StatefulWidget {
  const _PlayerScreenMobile({Key? key, required this.content})
      : super(key: key);
  final Content content;

  @override
  State<_PlayerScreenMobile> createState() => _PlayerScreenMobileState();
}

class _PlayerScreenMobileState extends State<_PlayerScreenMobile> {
  late Future<List<dynamic>> _combinedFutures;
  @override
  void initState() {
    super.initState();
    _combinedFutures = Future.wait([
      getTrending(),
    ]);
    recordClick(widget.content.id!);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isPlayer: true,
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _combinedFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var combinedData = snapshot.data!;
            var trendingContent =
                List<Content>.from(combinedData[0] as List<dynamic>);

            return SingleChildScrollView(
              child: Column(
                children: [
                  HeaderPlayer(VideoUrl: widget.content.videoUrl!),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: VideoDescription(
                      title: widget.content.name,
                      description: widget.content.description!,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NeatflixRatingBar(),
                  ),
                  const SizedBox(height: 10.0),
                  VerticalIconButton(
                    icon: Icons.add,
                    title: 'List',
                    onTap: () async {
                      await addUserPlayList(context, widget.content.id!);
                    },
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomScrollView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          sliver: SliverToBoxAdapter(
                            child: ContentList(
                              key: PageStorageKey('trending'),
                              title: 'Trending',
                              contentList: trendingContent,
                              isOriginals: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(); // Fallback for unexpected state
        },
      ),
    );
  }
}

class _PlayerScreenDesktop extends StatefulWidget {
  const _PlayerScreenDesktop({Key? key, required this.content})
      : super(key: key);
  final Content content;
  @override
  State<_PlayerScreenDesktop> createState() => _PlayerScreenDesktopState();
}

class _PlayerScreenDesktopState extends State<_PlayerScreenDesktop> {
  @override
  void initState() {
    recordClick(widget.content.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isPlayer: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderPlayer(VideoUrl: widget.content.videoUrl!),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: VideoDescription(
                        title: widget.content.name,
                        description: widget.content.description!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NeatflixRatingBar(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: VerticalIconButton(
                        icon: Icons.add,
                        title: 'List',
                        onTap: () async {
                          await addUserPlayList(context, widget.content.id!);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: VerticalIconButton(
                        icon: Icons.share,
                        title: 'Share',
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: VerticalIconButton(
                        icon: Icons.download,
                        title: 'Download',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
