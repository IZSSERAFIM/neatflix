import 'package:flutter/material.dart';
import 'package:neatflix/cubits/cubits.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/models/models.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _SearchScreenMobile(),
      desktop: _SearchScreenDesktop(),
    );
  }
}

class _SearchScreenMobile extends StatefulWidget {
  const _SearchScreenMobile({super.key});

  @override
  State<_SearchScreenMobile> createState() => _SearchScreenMobileState();
}

class _SearchScreenMobileState extends State<_SearchScreenMobile> {
  ScrollController _scrollcontroller = ScrollController();
  late Future<List<dynamic>> _combinedFutures;
  List<Content> searchResultsTitle = [];
  List<Content> searchResultsCategory = [];

  @override
  void initState() {
    _scrollcontroller = ScrollController()
      ..addListener(() {
        context.read<AppBarCubit>().setOffset(_scrollcontroller.offset);
      });
    super.initState();
    _combinedFutures = Future.wait([
      getTrending(),
    ]);
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    super.dispose();
  }

  void onQueryChanged(String query) async {
    try {
      final results = await search(query);
      setState(() {
        searchResultsTitle = results;
      });
    } catch (e) {
      print('Error searching: $e');
    }
  }

  void onCategorySelected(List<Content> contents) {
    setState(() {
      searchResultsCategory = contents;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: BlocBuilder<AppBarCubit, double>(
          builder: (context, scrollOffset) {
            return CustomAppBar(
              scrollOffset: scrollOffset,
              isSearch: true,
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
            var trendingContent =
                List<Content>.from(combinedData[0] as List<dynamic>);

            // 合并并去重搜索结果
            final searchResultsSet = {
              ...searchResultsTitle,
              ...searchResultsCategory
            };
            final uniqueSearchResults = searchResultsSet.toList();

            return CustomScrollView(
              controller: _scrollcontroller,
              slivers: [
                SliverToBoxAdapter(
                  child: NeatflixSearchBar(
                    onQueryChanged: onQueryChanged,
                  ),
                ),
                SliverToBoxAdapter(
                  child: CategoryBar(
                    onCategorySelected: onCategorySelected,
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
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: ContentList(
                      key: PageStorageKey('search'),
                      title: 'Search Results',
                      contentList: uniqueSearchResults,
                      isOriginals: true,
                    ),
                  ),
                ),
              ],
            );
          }
          return Container(); // Fallback for unexpected state
        },
      ),
    );
  }
}

class _SearchScreenDesktop extends StatefulWidget {
  const _SearchScreenDesktop({super.key});

  @override
  State<_SearchScreenDesktop> createState() => _SearchScreenDesktopState();
}

class _SearchScreenDesktopState extends State<_SearchScreenDesktop> {
  late Future<List<dynamic>> _combinedFutures;
  List<Content> searchResults = [];
  List<Content> searchResultsTitle = [];
  List<Content> searchResultsCategory = [];
  @override
  void initState() {
    super.initState();
    _combinedFutures = Future.wait([
      getTrending(),
    ]);
  }

  void onQueryChanged(String query) async {
    try {
      final results = await search(query);
      setState(() {
        searchResultsTitle = results;
      });
    } catch (e) {
      print('Error searching: $e');
    }
  }

  void onCategorySelected(List<Content> contents) {
    setState(() {
      searchResultsCategory = contents;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isSearch: true,
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

            // 合并并去重搜索结果
            final searchResultsSet = {
              ...searchResultsTitle,
              ...searchResultsCategory
            };
            final uniqueSearchResults = searchResultsSet.toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: NeatflixSearchBar(
                    onQueryChanged: onQueryChanged,
                  ),
                ),
                SliverToBoxAdapter(
                  child: CategoryBar(
                    onCategorySelected: onCategorySelected,
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
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: ContentList(
                      key: PageStorageKey('search'),
                      title: 'Search Results',
                      contentList: uniqueSearchResults,
                      isOriginals: true,
                    ),
                  ),
                ),
              ],
            );
          }
          return Container(); // Fallback for unexpected state
        },
      ),
    );
  }
}
