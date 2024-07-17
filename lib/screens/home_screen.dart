import 'package:flutter/material.dart';
import 'package:neatflix/cubits/cubits.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatflix/models/models.dart';
import 'package:neatflix/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _HomeScreenMobile(),
      desktop: _HomeScreenDesktop(),
    );
  }
}

class _HomeScreenMobile extends StatefulWidget {
  const _HomeScreenMobile({Key? key}) : super(key: key);

  @override
  State<_HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<_HomeScreenMobile> {
  ScrollController _scrollcontroller = ScrollController();
  late Future<List<dynamic>> _combinedFutures;

  @override
  void initState() {
    _scrollcontroller = ScrollController()
      ..addListener(() {
        context.read<AppBarCubit>().setOffset(_scrollcontroller.offset);
      });
    super.initState();
    _combinedFutures = Future.wait([
      getHeader(),
      getPreviews(), // 确保 getPreviews 返回的是 Future<List<Content>>
      getUserPlayList(),
      getOriginals(),
      getTrending(),
      getUserHistory(),
    ]);
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: BlocBuilder<AppBarCubit, double>(
          builder: (context, scrollOffset) {
            return CustomAppBar(
              scrollOffset: scrollOffset,
              isHome: true,
            );
          },
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
            var headerContent = combinedData[0] as Content;
            var previewsContent =
                List<Content>.from(combinedData[1] as List<dynamic>);
            var listContent =
                List<Content>.from(combinedData[2] as List<dynamic>);
            var originalsContent =
                List<Content>.from(combinedData[3] as List<dynamic>);
            var trendingContent =
                List<Content>.from(combinedData[4] as List<dynamic>);
            var historyContent =
                List<Content>.from(combinedData[5] as List<dynamic>);

            return CustomScrollView(
              controller: _scrollcontroller,
              slivers: [
                SliverToBoxAdapter(
                  child: ContentHeader(
                    key: PageStorageKey('contentheader'),
                    featuredContent: headerContent,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: Previews(
                      key: PageStorageKey('previews'),
                      title: 'Previews',
                      contentList: previewsContent,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey('myList'),
                    title: 'My List',
                    contentList: listContent,
                    isOriginals: false,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey('originals'),
                    title: 'Neatflix Originals',
                    contentList: originalsContent,
                    isOriginals: true,
                  ),
                ),
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
                SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey('watchhistory'),
                    title: 'Watched History',
                    contentList: historyContent,
                    isOriginals: false,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

class _HomeScreenDesktop extends StatefulWidget {
  const _HomeScreenDesktop({super.key});

  @override
  State<_HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<_HomeScreenDesktop> {
  late Future<Content> _headerContentFuture;
  late Future<List<dynamic>> _combinedFutures;
  @override
  void initState() {
    super.initState();
    _combinedFutures = Future.wait([
      getHeader(),
      getPreviews(), // 确保 getPreviews 返回的是 Future<List<Content>>
      getUserPlayList(),
      getOriginals(),
      getTrending(),
      getUserHistory(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isHome: true,
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
            var headerContent = combinedData[0] as Content;
            var previewsContent =
                List<Content>.from(combinedData[1] as List<dynamic>);
            var listContent =
                List<Content>.from(combinedData[2] as List<dynamic>);
            var originalsContent =
                List<Content>.from(combinedData[3] as List<dynamic>);
            var trendingContent =
                List<Content>.from(combinedData[4] as List<dynamic>);
            var historyContent =
                List<Content>.from(combinedData[5] as List<dynamic>);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ContentHeader(
                    key: PageStorageKey('contentheader'),
                    featuredContent: headerContent,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: Previews(
                      key: PageStorageKey('previews'),
                      title: 'Previews',
                      contentList: previewsContent,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey('myList'),
                    title: 'My List',
                    contentList: listContent,
                    isOriginals: false,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey('originals'),
                    title: 'Neatflix Originals',
                    contentList: originalsContent,
                    isOriginals: true,
                  ),
                ),
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
                SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey('watchhistory'),
                    title: 'Watched History',
                    contentList: historyContent,
                    isOriginals: false,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
